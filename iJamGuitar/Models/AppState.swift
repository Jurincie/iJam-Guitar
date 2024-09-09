//
//  AppState.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 2/6/24.
//

import SwiftData
import SwiftUI
import OSLog

@Model
final class AppState {
    // Stored Properties
    var isMuted: Bool = false
    var showVolumeAlert: Bool = false
    var showAudioPlayerInUseAlert: Bool = false
    var showAudioNotAvailableAlert: Bool = false
    var showAudioPlayerErrorAlert: Bool = false
    var capoPosition: Int = 0
    var volumeLevel: Double = 5.0
    var savedVolumeLevel: Double = 5.0
    var pickerChordGroupName: String = ""
    var pickerTuningName: String = ""
    
    // currentFretPositions represents the 
    // CURRENT fret position for each string irrespective of capo position
    // which may have changed via tapping on frets from when latest chord change
    var currentFretPositions: [Int] = []

    init() {}
    
    // Relationships
    @Relationship(deleteRule: .nullify) var activeTuning: Tuning? = nil
    @Relationship(deleteRule: .cascade) var tunings: [Tuning] = []
    
    // Calculated Properties
    var tuningNames: [String] {
        get {
            return tunings.compactMap() { tuning in
                tuning.name
            }
        }
    }
    var activeChordGroup: ChordGroup? {
        get {
            activeTuning?.activeChordGroup
        }
    }
    var activeChordFretMap: [Int] {
        get {
            var array = [Int]()
            
            if let fretMap = activeTuning?.activeChordGroup?.activeChord?.fretMapString {
                for char in fretMap {
                    if let value = char.hexDigitValue {
                        array.append(value)
                    } else {
                        array.append(-1)
                    }
                }
            }
            return array
        }
    }
    var minimumFret: Int {
        get {
            if let activeChord = activeChordGroup?.activeChord {
                let fretChars = activeChord.fretMapString
                var highest = 0
                
                for char in fretChars {
                    if let value = char.hexDigitValue {
                        if value > highest {
                            highest = value
                        }
                    }
                }
                return highest < 6 ? 1 : max(1, highest - 4)
            } else {
                Logger.viewCycle.debug("Could NOT calculate minimumFret")
                return 0
            }
        }
    }
}

enum PlistError: Error {
    case badChordLibraryAddress
    case badChordGroupAddress
    case unknownError
}
