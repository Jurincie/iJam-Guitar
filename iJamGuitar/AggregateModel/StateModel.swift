//
//  StateModel.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 8/19/24.
//

import Foundation
import SwiftData
import SwiftUI
import AVFoundation

/// This is an aggregrate model as part of Apple's MV Architecture
///

struct StateModel {
    let audioManager = iJamAudioManager()
    var noteNamesArray = ["DoubleLow_C.wav", "DoubleLow_C#.wav", "DoubleLow_D.wav", "DoubleLow_D#.wav", "Low_E.wav", "Low_F.wav", "Low_F#.wav", "Low_G.wav", "Low_G#.wav", "Low_A.wav", "Low_A#.wav", "Low_B.wav", "Low_C.wav", "Low_C#.wav", "Low_D.wav", "Low_D#.wav", "E.wav", "F.wav", "F#.wav", "G.wav", "G#.wav", "A.wav", "A#.wav", "B.wav", "C.wav", "C#.wav", "D.wav", "D#.wav", "High_E.wav", "High_F.wav", "High_F#.wav", "High_G.wav", "High_G#.wav", "High_A.wav", "High_A#.wav", "High_B.wav", "High_C.wav", "High_C#.wav", "High_D.wav", "High_D#.wav", "DoubleHigh_E.wav", "DoubleHigh_F.wav", "DoubleHigh_F#.wav"]
    
    var isDeviceVolumeLevelZero: Bool {
        return AVAudioSession.sharedInstance().outputVolume == 0.0
    }
 
    func fretIsInChord(stringNumber: Int,
                       newFretNumber: Int,
                       currentChordFretMap: [Int]) -> Bool {
        newFretNumber == currentChordFretMap[6 - stringNumber]
    }
    
    func createChord(name: String, tuning: Tuning?) -> Chord? {
        if let chordDic = tuning?.chordsDictionary,
           let entry = chordDic.first(where: { (key: String, value: String) in
               name == key
           }){
            return Chord(name: entry.key,
                         fretMapString: entry.value)
        }
        return nil
    }
}
