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
    var showVolumeAlert = false
    var showAudioPlayerInUseAlert = false
    var showAudioNotAvailableAlert = false
    var showAudioPlayerErrorAlert = false
    let kDefaultVolume = 5.0
    var minimumFret: Int = 0
    var currentFretIndexMap: [Int] = []
    var capoPosition: Int = 0
    var isMuted: Bool = false
    var volumeLevel: Double = 5.0
    var selectedChordIndex: Int = 0
    var savedVolumeLevel: Double = 5.0
    
    // Relationships
    @Relationship(deleteRule: .cascade) var tunings: [Tuning]
    @Relationship var activeTuning: Tuning?
    
    // Calculated Properties
    var activeChord: Chord? {
        get {
            activeTuning?.activeChordGroup?.activeChord
        }
        
        set { }
    }
    var activeChordGroup: ChordGroup? {
        get {
            activeTuning?.activeChordGroup
        }
        set { }
    }
    var availableChords: [Chord] {
        get {
            activeChordGroup?.availableChords ?? []
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
        activeChord: Chord? = nil,
        showVolumeAlert: Bool = false,
        showAudioPlayerInUseAlert: Bool = false,
        showAudioNotAvailableAlert: Bool = false,
        showAudioPlayerErrorAlert: Bool = false,
        minimumFret: Int = 0,
        currentFretIndexMap: [Int] = [],
        capoPosition: Int = 0,
        isMuted: Bool = false,
        volumeLevel: Double = 5.0,
        selectedChordIndex: Int = 0,
        savedVolumeLevel: Double = 5.0) {
            self.activeTuningName = activeTuningName
            self.activeChord = activeChord
            self.showVolumeAlert = showVolumeAlert
            self.showAudioPlayerInUseAlert = showAudioPlayerInUseAlert
            self.showAudioNotAvailableAlert = showAudioNotAvailableAlert
            self.showAudioPlayerErrorAlert = showAudioPlayerErrorAlert
            self.minimumFret = minimumFret
            self.currentFretIndexMap = currentFretIndexMap
            self.capoPosition = capoPosition
            self.isMuted = isMuted
            self.volumeLevel = volumeLevel
            self.selectedChordIndex = selectedChordIndex
            self.savedVolumeLevel = savedVolumeLevel
        }
}

enum PlistError: Error {
    case badChordGroupsLibraryAddress
    case badChordLibraryAddress
    case unknownError
}
