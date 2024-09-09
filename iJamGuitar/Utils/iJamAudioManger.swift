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

enum AudioError: Error {
    case InitializeSoundsError
    case MissingResourseError
    case AVAudioSessionError
    case AVAudioPlayerInUse
    case UnknownError
}

class iJamAudioManager {
    // 1 audioPlayer for each string
    var audioPlayerArray = [AVAudioPlayer?]()

    init() {
        do {
            try initializeAVAudioSession()
            try loadWaveFilesIntoAudioPlayers()
        } catch {
            print(error.localizedDescription)
            fatalError()
        }
    }
   
    func initializeAVAudioSession() throws {
        do {
            // Attempts to activate session so you can play audio,
            // if other sessions have priority this will fail
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            Logger.statistics.error("\(error.localizedDescription)")
            throw AudioError.AVAudioSessionError
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
                        throw AudioError.AVAudioPlayerInUse
                    }
                    audioPlayerArray.append(thisAudioPlayer)
                } catch AudioError.AVAudioSessionError{
                    fatalError()
                }
                catch {
                    Logger.errors.error("\(error.localizedDescription)")
                    throw AudioError.InitializeSoundsError
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
                let thisAudioPlayer = try AVAudioPlayer(data:asset.data, fileTypeHint:"wav")
                audioPlayerArray[6 - stringNumber] = thisAudioPlayer
                thisAudioPlayer.volume = Float(volume) / 5.0
                thisAudioPlayer.prepareToPlay()
                thisAudioPlayer.play()
            }
            catch AudioError.AVAudioSessionError{
                throw AudioError.AVAudioSessionError
            }
            catch {
                throw AudioError.UnknownError
            }
        }
    }
}
