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
    var showVolumeAlert: Bool
    var showAudioPlayerInUseAlert: Bool
    var showAudioNotAvailableAlert: Bool
    var showAudioPlayerErrorAlert: Bool
    var isMuted: Bool
    var capoPosition: Int
    var volumeLevel: Double
    var savedVolumeLevel: Double
    var pickerChordGroupName: String = ""
    var pickerTuningName: String = ""

    // Relationships
    @Relationship(deleteRule: .nullify) var activeTuning: Tuning? = nil
    @Relationship(deleteRule: .cascade) var tunings: [Tuning]
    
    // Calculated Properties
    var selectedChordIndex: Int {
        if let chord = activeChordGroup?.activeChord {
            if let index = activeChordGroup?.availableChords.firstIndex(of: chord) {
                return index
            }
        }
        Logger.viewCycle.debug("Faild to set selectedChordIndex")
        return 0
    }
    var activeChordGroup: ChordGroup? {
        get {
            activeTuning?.activeChordGroup
        }
        set {
            activeTuning?.activeChordGroup = newValue
        }
    }
    var currentFretIndexMap: [Int] {
        get {
            getFretIndexMap(chord: activeChordGroup?.activeChord)
        }
        set {}
    }
    var minimumFret: Int {
        get {
            if let activeChord = activeChordGroup?.activeChord {
                let fretChars = activeChord.fretMapString
                
                var highest = 0
                var thisFretVal = 0
                
                for char in fretChars {
                    thisFretVal = getFretFromChar(char)
                    if thisFretVal > highest {
                        highest = thisFretVal
                    }
                }
                
                return highest < 6 ? 1 : max(1, highest - 4)
            }
            
            Logger.viewCycle.debug("Could NOT calculate minimumFret")
            return 0
        }
    }
    
    init(showVolumeAlert: Bool = false,
         showAudioPlayerInUseAlert: Bool = false,
         showAudioNotAvailableAlert: Bool = false,
         showAudioPlayerErrorAlert: Bool = false,
         isMuted: Bool = false,
         capoPosition: Int = 0,
         volumeLevel: Double = 5.0,
         savedVolumeLevel: Double = 5.0) {
        self.showVolumeAlert = showVolumeAlert
        self.showAudioPlayerInUseAlert = showAudioPlayerInUseAlert
        self.showAudioNotAvailableAlert = showAudioNotAvailableAlert
        self.showAudioPlayerErrorAlert = showAudioPlayerErrorAlert
        self.isMuted = isMuted
        self.capoPosition = capoPosition
        self.volumeLevel = volumeLevel
        self.savedVolumeLevel = savedVolumeLevel
        self.tunings = [Tuning]()
    }
}

enum PlistError: Error {
    case badChordGroupsLibraryAddress
    case badChordLibraryAddress
    case unknownError
}
