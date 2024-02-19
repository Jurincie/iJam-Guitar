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
    case AVAudioPlayerInUse
    case UnknownError
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = CGRectZero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

class iJamAudioManager {
    var audioPlayerArray    = [AVAudioPlayer?]() // 1 audioPlayer for each string 6-1
    var noteNamesArray      = ["DoubleLow_C.wav", "DoubleLow_C#.wav", "DoubleLow_D.wav", "DoubleLow_D#.wav", "Low_E.wav", "Low_F.wav", "Low_F#.wav", "Low_G.wav", "Low_G#.wav", "Low_A.wav", "Low_A#.wav", "Low_B.wav", "Low_C.wav", "Low_C#.wav", "Low_D.wav", "Low_D#.wav", "E.wav", "F.wav", "F#.wav", "G.wav", "G#.wav", "A.wav", "A#.wav", "B.wav", "C.wav", "C#.wav", "D.wav", "D#.wav", "High_E.wav", "High_F.wav", "High_F#.wav", "High_G.wav", "High_G#.wav", "High_A.wav", "High_A#.wav", "High_B.wav", "High_C.wav", "High_C#.wav", "High_D.wav", "High_D#.wav", "DoubleHigh_E.wav", "DoubleHigh_F.wav", "DoubleHigh_F#.wav"]
    
    init() {
        try? initializeAVAudioSession()
        try? loadWaveFilesIntoAudioPlayers()
    }
   
    func initializeAVAudioSession() throws {
        do {
            // Attempts to activate session so you can play audio,
            // if other sessions have priority this will fail
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            Logger.statistics.error("\(error.localizedDescription)")
            throw InitializeErrors.AVAudioSessionError
        }
    }
    
    /// This method instantiates one AudioPlayer for each string
    func loadWaveFilesIntoAudioPlayers() throws {
        for _ in 0...5 {
            if let asset = NSDataAsset(name:"NoNote") {
                do {
                    let thisAudioPlayer = try AVAudioPlayer(data:asset.data,
                                                            fileTypeHint:"wav")
                    if thisAudioPlayer.isPlaying {
                        throw InitializeErrors.AVAudioPlayerInUse
                    }
                    audioPlayerArray.append(thisAudioPlayer)
                } catch InitializeErrors.AVAudioSessionError{
                    fatalError()
                }
                catch {
                    Logger.errors.error("\(error.localizedDescription)")
                    throw InitializeErrors.InitializeSoundsError
                }
            }
        }
    }

    func playWaveFile(noteName: String,
                      stringNumber: Int,
                      volume: Double) throws {
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
                throw InitializeErrors.AVAudioSessionError
            }
            catch {
                throw InitializeErrors.UnknownError
            }
        }
    }
}
