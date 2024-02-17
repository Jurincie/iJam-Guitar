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
    var minimumFret: Int
    var volumeLevel: Double
    var savedVolumeLevel: Double
    var selectedChordIndex: Int
    var pickerChordGroupName: String = ""
    var pickerTuningName: String = ""

    // Relationships
    @Relationship(deleteRule: .nullify) var activeTuning: Tuning? = nil
    @Relationship(deleteRule: .cascade) var tunings: [Tuning]
    
    // Calculated Properties
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
    }
    
    init(showVolumeAlert: Bool = false,
         showAudioPlayerInUseAlert: Bool = false,
         showAudioNotAvailableAlert: Bool = false,
         showAudioPlayerErrorAlert: Bool = false,
         isMuted: Bool = false,
         capoPosition: Int = 0,
         minimumFret: Int = 0,
         selectedChordIndex: Int = 0,
         volumeLevel: Double = 5.0,
         savedVolumeLevel: Double = 5.0) {
        self.showVolumeAlert = showVolumeAlert
        self.showAudioPlayerInUseAlert = showAudioPlayerInUseAlert
        self.showAudioNotAvailableAlert = showAudioNotAvailableAlert
        self.showAudioPlayerErrorAlert = showAudioPlayerErrorAlert
        self.isMuted = isMuted
        self.capoPosition = capoPosition
        self.minimumFret = minimumFret
        self.selectedChordIndex = selectedChordIndex
        self.volumeLevel = volumeLevel
        self.savedVolumeLevel = savedVolumeLevel
        self.tunings = [Tuning]()
    }
    
    func setNewActiveChordFromPickIndex(_ index: Int) {
        Logger.viewCycle.notice("setNewActiveChordFromPickIndex called for Index: \(index)")
    }
}

enum PlistError: Error {
    case badChordGroupsLibraryAddress
    case badChordLibraryAddress
    case unknownError
}
