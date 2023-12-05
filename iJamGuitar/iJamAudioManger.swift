//
//  iJamAudioManger.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/26/23.
//

import Foundation
import SwiftUI
import AVFoundation
import OSLog

enum InitializeErrors: Error {
    case InitializeSoundsError
    case MissingResourseError
    case AVAudioSessionError
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = CGRectZero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

class iJamAudioManager {
    @Bindable var model: iJamModel
    let kNoFret             = -1
    let kHalfStringWidth    = 5.0
    var formerZone          = -1
    var zoneBreaks:[Double] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var audioPlayerArray    = [AVAudioPlayer?]() // 1 audioPlayer for each string 6-1
    var noteNamesArray      = ["DoubleLow_C.wav", "DoubleLow_C#.wav", "DoubleLow_D.wav", "DoubleLow_D#.wav", "Low_E.wav", "Low_F.wav", "Low_F#.wav", "Low_G.wav", "Low_G#.wav", "Low_A.wav", "Low_A#.wav", "Low_B.wav", "Low_C.wav", "Low_C#.wav", "Low_D.wav", "Low_D#.wav", "E.wav", "F.wav", "F#.wav", "G.wav", "G#.wav", "A.wav", "A#.wav", "B.wav", "C.wav", "C#.wav", "D.wav", "D#.wav", "High_E.wav", "High_F.wav", "High_F#.wav", "High_G.wav", "High_G#.wav", "High_A.wav", "High_A#.wav", "High_B.wav", "High_C.wav", "High_C#.wav", "High_D.wav", "High_D#.wav", "DoubleHigh_E.wav", "DoubleHigh_F.wav", "DoubleHigh_F#.wav"]
    
    init(model: iJamModel) {
        self.model = model
        initializeAVAudioSession()
        loadWaveFilesIntoAudioPlayers()
    }
    
    func initializeAVAudioSession() {
        do {
            // Attempts to activate session so you can play audio,
            // if other sessions have priority this will fail
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            model.showAudioPlayerErrorAlert = true
            Logger.statistics.error("\(error.localizedDescription)")
            fatalError()
        }
    }

    func loadWaveFilesIntoAudioPlayers() {
        for _ in 0...5 {
            if let asset = NSDataAsset(name:"NoNote") {
                do {
                    let thisAudioPlayer = try AVAudioPlayer(data:asset.data, fileTypeHint:"wav")
                    if thisAudioPlayer.isPlaying {
                        model.showAudioPlayerInUseAlert = true
                    }
                    audioPlayerArray.append(thisAudioPlayer)
                } catch InitializeErrors.AVAudioSessionError{ fatalError() }
                catch {
                    model.showAudioPlayerErrorAlert = true
                    Logger.errors.error("\(error.localizedDescription)")
                    fatalError()
                }
            }
        }
    }
    
    func getZone(loc: CGPoint) -> Int{
        // ZoneBreaks[n] is left-most position of string[6-n]
        var zone = 0
        
        if loc.x < zoneBreaks[0] {
            zone = 0  // left of string 6
        } else if loc.x <= zoneBreaks[0] + kHalfStringWidth {
            zone = 1 // over string 6
        } else if loc.x < zoneBreaks[1] {
            zone = 2  // between string 6 and string 5
        } else if loc.x <= zoneBreaks[1] + kHalfStringWidth {
            zone = 3 // over string 5
        } else if loc.x < zoneBreaks[2] {
            zone = 4  // between string 5 and string 4
        } else if loc.x <= zoneBreaks[2] + kHalfStringWidth {
            zone = 5 // over string 4
        } else if loc.x < zoneBreaks[3] {
            zone = 6  // between string 4 and string 3
        } else if loc.x <= zoneBreaks[3] + kHalfStringWidth {
            zone = 7 // over string 3
        } else if loc.x < zoneBreaks[4] {
            zone = 8  // between string 3 and string 2
        } else if loc.x <= zoneBreaks[4] + kHalfStringWidth {
            zone = 9 // over string 2
        } else if loc.x < zoneBreaks[5] {
            zone = 10  // between string 2 and string 1
        } else if loc.x <= zoneBreaks[5] + kHalfStringWidth {
            zone = 11 // over string 1
        } else {
            zone = 12  // right of string 1
        }
        
        return zone
    }
    
    ///   Description:
    ///     if moving to left play string to right -
    ///     if moving to right play string to left
    /// - Parameters:
    ///   - zone: the zone where drag resides
    ///   - oldZone: the former Zone
    /// - Returns: String number to play
    func stringNumberToPlay(zone: Int, oldZone: Int) -> Int {
        guard oldZone != -1  else { return 0 }
        
        var stringNumber = (6 - (zone / 2))
        
        if oldZone < zone && zone != 0 {
            stringNumber += 1
        }
        
        return stringNumber
    }
    
    ///   Description: This method determines if we are in a new zone -
    ///   and if we should then play note on appropriate string
    /// - Parameter location:- the current location of the drag in global co-ordinates
    func newDragLocation(_ location: CGPoint?) {
        guard let location =  location else { return }
        let zone = getZone(loc: location)
        guard zone != formerZone else { return }
        Logger.viewCycle.notice("====> In New Zone: \(zone)")

        let stringToPlay: Int = stringNumberToPlay(zone: zone, oldZone: formerZone)
        if shouldPickString(zone: zone, stringNumber: stringToPlay) {
            pickString(stringToPlay)
        }
        formerZone = zone
    }
    
    func shouldPickString(zone: Int, stringNumber: Int) -> Bool {
        var answer = false
        if zone % 2 == 0 && model.isMuted == false {
            answer = stringNumber > 0 && stringNumber < 7
        }
        
        return answer
    }
    
    /// Description: This method identifies the note to play on this string based on capo position and fret -
    ///  and then plays that string if the string is not muted
    /// - Parameter stringToPlay: The String to be played
    func pickString(_ stringToPlay: Int) {
        let openNotes = model.activeTuning?.openNoteIndices.components(separatedBy: "-")
        let fretPosition = model.fretIndexMap[6 - stringToPlay]
        
        if fretPosition > kNoFret {
            if let noteIndices = openNotes, let thisStringsOpenIndex = Int(noteIndices[6 - stringToPlay]) {
                let index = fretPosition + thisStringsOpenIndex + model.capoPosition
                let noteToPlayName = noteNamesArray[index]
                let volume = model.volumeLevel

                playWaveFile(noteName:noteToPlayName,
                             stringNumber: stringToPlay,
                             volume: volume / 5.0)
            }
        }
    }
    
    func playWaveFile(noteName: String,
                      stringNumber: Int,
                      volume: Double) {
        let prefix = String(noteName.prefix(noteName.count - 4))  // trims ".wav" from end
        Logger.viewCycle.notice("-> playing String: \(stringNumber) note: \(noteName)")
        if let asset = NSDataAsset(name:prefix) {
            do {
                let thisAudioPlayer                 = try AVAudioPlayer(data:asset.data, fileTypeHint:"wav")
                audioPlayerArray[6 - stringNumber]  = thisAudioPlayer
                thisAudioPlayer.volume              = Float(volume) / 5.0
                thisAudioPlayer.prepareToPlay()
                thisAudioPlayer.play()
            }
            catch InitializeErrors.AVAudioSessionError{
                model.showAudioPlayerErrorAlert = true
            }
            catch {
                model.showAudioPlayerErrorAlert = true
            }
        }
    }
}
