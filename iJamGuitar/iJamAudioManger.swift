//
//  iJamAudioManger.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/26/23.
//

import AVFoundation
import OSLog
import SwiftData
import SwiftUI

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
    let appStates: [AppState] = []
    let kNoFret             = -1
    let kHalfStringWidth    = 5.0
    var formerZone          = -1
    var zoneBreaks:[Double] = Array(repeating: 0.0, count: 6)
    var audioPlayerArray    = [AVAudioPlayer?]() // 1 audioPlayer for each string 6-1
    var noteNamesArray      = ["DoubleLow_C.wav", "DoubleLow_C#.wav", "DoubleLow_D.wav", "DoubleLow_D#.wav", "Low_E.wav", "Low_F.wav", "Low_F#.wav", "Low_G.wav", "Low_G#.wav", "Low_A.wav", "Low_A#.wav", "Low_B.wav", "Low_C.wav", "Low_C#.wav", "Low_D.wav", "Low_D#.wav", "E.wav", "F.wav", "F#.wav", "G.wav", "G#.wav", "A.wav", "A#.wav", "B.wav", "C.wav", "C#.wav", "D.wav", "D#.wav", "High_E.wav", "High_F.wav", "High_F#.wav", "High_G.wav", "High_G#.wav", "High_A.wav", "High_A#.wav", "High_B.wav", "High_C.wav", "High_C#.wav", "High_D.wav", "High_D#.wav", "DoubleHigh_E.wav", "DoubleHigh_F.wav", "DoubleHigh_F#.wav"]
    
    init(formerZone: Int = -1) {
        self.formerZone = formerZone
        
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
            appStates.first?.showAudioPlayerErrorAlert = true
            Logger.statistics.error("\(error.localizedDescription)")
            fatalError()
        }
    }
    
    /// This method instantiates one AudioPlayer for each string
    func loadWaveFilesIntoAudioPlayers() {
        for _ in 0...5 {
            if let asset = NSDataAsset(name:"NoNote") {
                do {
                    let thisAudioPlayer = try AVAudioPlayer(data:asset.data,
                                                            fileTypeHint:"wav")
                    if thisAudioPlayer.isPlaying {
                        appStates.first?.showAudioPlayerInUseAlert = true
                    }
                    audioPlayerArray.append(thisAudioPlayer)
                } catch InitializeErrors.AVAudioSessionError{
                    fatalError()
                }
                catch {
                    appStates.first?.showAudioPlayerErrorAlert = true
                    Logger.errors.error("\(error.localizedDescription)")
                    fatalError()
                }
            }
        }
    }
    
    func getZone(loc: CGPoint) -> Int{
        // ZoneBreaks[n] is left-most position of string[n + 1]
        var zone = 0
        
        if loc.x < zoneBreaks[0] {
            zone = 6    // left of string 6
        } else if loc.x < zoneBreaks[1] {
            zone = 5    // between string 6 and string 5
        } else if loc.x < zoneBreaks[2] {
            zone = 4  // between string 5 and string 4
        } else if loc.x < zoneBreaks[3] {
            zone = 3  // between string 4 and string 3
        } else if loc.x < zoneBreaks[4] {
            zone = 2  // between string 3 and string 2
        } else if loc.x < zoneBreaks[5] {
            zone = 1  // between string 2 and string 1
        } else {
            zone = 0  // right of string 1
        }
        
        return zone
    }
    
    func stringNumberToPlay(zone: Int, oldZone: Int) -> Int {
        return oldZone > zone ? oldZone : zone
    }
    
    ///   Description: This method determines if we are in a new zone -
    ///   and if we should then play note on appropriate string
    /// - Parameter location:- the current location of the drag in global co-ordinates
    func newDragLocation(_ location: CGPoint?) {
        guard let location =  location else { return }
        
        let zone = getZone(loc: location)
        if zone != formerZone {
            Logger.viewCycle.notice("====> In New Zone: \(zone)")
            
            if formerZone >= 0 && appStates.first?.isMuted == false {
                if AVAudioSession.sharedInstance().outputVolume == 0.0 {
                    appStates.first?.showVolumeAlert = true
                } else {
                    let stringToPlay: Int = stringNumberToPlay(zone: zone, oldZone: formerZone)
                    pickString(stringToPlay)
                }
            }

            formerZone = zone
        }
    }
    
    /// Description: This method identifies the note to play on this string based on capo position and fret -
    ///  and then plays that string if the string is not muted
    /// - Parameter stringToPlay: The String to be played
    func pickString(_ stringToPlay: Int) {
        let openNotes = appStates.first?.activeTuning?.openNoteIndices.components(separatedBy: "-")
        
        if let fretPosition = appStates.first?.currentFretIndexMap[6 - stringToPlay] {
            if fretPosition > kNoFret {
                if let noteIndices = openNotes, let thisStringsOpenIndex = Int(noteIndices[6 - stringToPlay]) {
                    let index = fretPosition + thisStringsOpenIndex + (appStates.first?.capoPosition ?? 0)
                    let noteToPlayName = noteNamesArray[index]
                    
                    if let volume = appStates.first?.volumeLevel {
                        Logger.viewCycle.debug("playing string: \(stringToPlay)")
                        playWaveFile(noteName:noteToPlayName,
                                     stringNumber: stringToPlay,
                                     volume: volume / 5.0)
                    }
                }
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
                appStates.first?.showAudioPlayerErrorAlert = true
            }
            catch {
                appStates.first?.showAudioPlayerErrorAlert = true
            }
        }
    }
}
