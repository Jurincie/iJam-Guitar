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
    var currentFretIndexMap: [Int]
    var capoPosition: Int
    var minimumFret: Int
    var selectedChordIndex: Int
    var volumeLevel: Double
    var savedVolumeLevel: Double
    
    // Relationships
    @Relationship(deleteRule: .nullify)
    var activeTuning: Tuning? = nil
    
    @Relationship(deleteRule: .cascade)
    var tunings: [Tuning]?
    
    // Calculated Properties
    var activeChordGroup: ChordGroup? {
        get {
            activeTuning?.activeChordGroup
        }
        set { }
    }
    var activeTuningName: String {
        get {
            activeTuning?.name ?? "BAD Tuning Name"
        }
        set { 
            activeTuning = getTuning(name: newValue)
        }
    }
    var activeChordGroupName: String {
        get {
            activeTuning?.activeChordGroup?.name ?? "BAD ChordGroup Name"
        }
        set {
            activeChordGroup = getChordGroup(name: newValue)
        }
    }
    
    init(
        showVolumeAlert: Bool = false,
        showAudioPlayerInUseAlert: Bool = false,
        showAudioNotAvailableAlert: Bool = false,
        showAudioPlayerErrorAlert: Bool = false,
        isMuted: Bool = false,
        currentFretIndexMap: [Int] = [],
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
            self.currentFretIndexMap = currentFretIndexMap
            self.capoPosition = capoPosition
            self.minimumFret = minimumFret
            self.selectedChordIndex = selectedChordIndex
            self.volumeLevel = volumeLevel
            self.savedVolumeLevel = savedVolumeLevel
        }
}

enum PlistError: Error {
    case badChordGroupsLibraryAddress
    case badChordLibraryAddress
    case unknownError
}
