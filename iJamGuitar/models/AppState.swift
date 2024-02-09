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
    var activeChord: Chord? = nil
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
    var tunings = [Tuning]()
    var activeTuning: Tuning?
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
            activeTuning?.name ?? "BAD TUNING"
        }
        set { }
    }
    var activeChordGroupName: String {
        get {
            activeTuning?.activeChordGroup?.name ?? "BAD ChordGroup Name"
        }
        set { }
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
         savedVolumeLevel: Double = 5.0,
         tunings: [Tuning] = [Tuning](),
         activeTuning: Tuning? = nil) {
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
        self.tunings = tunings
        self.activeTuning = activeTuning
    }
}

extension AppState {
    private func setupModel() {
        // Create one instance of AppState
        // Attach created or existing Tunings to tunings: [Tuning]
        @Query var appState: AppState?
        
        if let appState = appState {
            do {
                try buildModelFromPlists()
            } catch {
                print("Error loading data")
            }
            
            // Now that AppState and [Tuning] exist -> connect them
            @Query var tunings: [Tuning]
            self.tunings.append(contentsOf: tunings)
            
            activeTuning = tunings.first
            activeTuning?.activeChordGroup = activeTuning?.chordGroups.first
            capoPosition = 0
            isMuted = false
            volumeLevel = Double(truncating: NSDecimalNumber(value: kDefaultVolume))
            
            activeTuning?.activeChordGroup?.availableChords = getAvailableChords(activeChordGroup: activeChordGroup,
                                                          activeTuning: activeTuning)
            currentFretIndexMap = getFretIndexMap(chord: activeTuning?.activeChordGroup?.activeChord)
            setSelectedChordIndex()
            
        }
        
        
    }
    
    private func buildModelFromPlists() throws {
        var appState = AppState()
        modelContext?.insert(appState)
        
        do {
            try createTuningsFromPlists()
        } catch {
            throw PlistError.unknownError
        }
    }
    
    func setSelectedChordIndex() {
        @Query var appState: AppState
        var chordIndex = 0
        
        for chord in appState.availableChords {
            if chord == appState.activeTuning?.activeChordGroup!.activeChord {
                break
            }
            chordIndex += 1
        }
        chordIndex = min(appState.availableChords.count - 1, appState.selectedChordIndex)
        
        appState.selectedChordIndex = chordIndex
    }
    
    /// This method sets all needed values for Tuning identified by tuningName
    /// and adds the new instantiated Tuning to the
    /// It should ONLY be callled on the initial launch to build the appState from iJamDataModel.xcaDataModel,
    /// which is then used by iJamModel.
    /// - Parameters:
    ///   - tuning: newly instantiated Tuning
    ///   - tuningName: name of this Tuning
    ///   - openIndices: represents each Strings (open position)  index into the noteNames Array
    ///   - noteNames: noteNames is an array of the noteNames
    ///   - chordLibraryPath: pathName for this Tuning's chords Dictionary
    ///   - chordGroupsPath: pathName for this Tuning's chordGroups Dictionary
    func setupTuning(tuning: Tuning,
                     tuningName: String,
                     openIndices: String,
                     noteNames: String,
                     chordLibraryPath: String,
                     chordGroupsPath: String) throws {
        tuning.name = tuningName
        tuning.openNoteIndices = openIndices
        tuning.stringNoteNames = noteNames
        
        guard let path = Bundle.main.path(forResource: chordLibraryPath, ofType: "plist"),
              let thisChordGroupChordDictionary = NSDictionary(contentsOfFile: path) as? [String: String]  else {
            throw PlistError.badChordLibraryAddress
        }
            
        let chords: [Chord] = convertToArrayOfChords(chordDictionary: thisChordGroupChordDictionary, parentTuning: tuning)
        tuning.chords.append(contentsOf: chords)
            
        guard let path = Bundle.main.path(forResource: chordGroupsPath, ofType: "plist"),
              let thisChordGroupsDict = NSDictionary(contentsOfFile: path) as? [String: String]  else {
            throw PlistError.badChordLibraryAddress
        }
        
        let chordGroups: [ChordGroup] = convertToArrayOfChordGroups(dict: thisChordGroupsDict, parentTuning: tuning)
        tuning.chordGroups.append(contentsOf: chordGroups)
        
        Logger.statistics.info("New tuning added")
    }
    
    /// This method should ONLY be called on initial launch of app
    /// It populated the appState with tunings specified in .plist and sets initial values for:
    /// capoPosition
    /// isMuted
    /// volumeLevel
    /// activeTuning
    /// eachTunings activeChordGroup
    /// each chordGroups activeChord
    func createTuningsFromPlists() throws {
        // populate our initial dataModel from Plists //
        
        // Standard Tuning
        let standardTuning = Tuning()
        
        do {
            try setupTuning(tuning: standardTuning,
                        tuningName: "Standard",
                        openIndices: "4-9-14-19-23-28",
                        noteNames: "E-A-D-G-B-E",
                        chordLibraryPath: "StandardTuning_ChordLibrary",
                        chordGroupsPath: "StandardTuningChordGroups")
        } catch {
            throw PlistError.unknownError
        }
        
        // Drop-D Tuning
        let dropDTuning = Tuning()
        do {
            try setupTuning(tuning: dropDTuning,
                            tuningName: "Drop D",
                            openIndices: "2-9-14-19-23-28",
                            noteNames: "D-A-D-G-B-E",
                            chordLibraryPath: "DropD_ChordLibrary",
                            chordGroupsPath: "DropDTuningChordGroups")
        } catch {
            throw PlistError.unknownError
        }
        
        
        // Open D Tuning
        let openDTuning = Tuning()
        do {
            try setupTuning(tuning: openDTuning,
                            tuningName: "Open D",
                            openIndices: "2-9-14-18-21-26",
                            noteNames: "D-A-D-F#-A-D",
                            chordLibraryPath: "OpenD_ChordLibrary",
                            chordGroupsPath: "OpenDTuningChordGroups")
        } catch {
            throw PlistError.unknownError
        }
        
        modelContext?.insert(standardTuning)
        modelContext?.insert(dropDTuning)
        modelContext?.insert(openDTuning)
    }
    
    /// Creates and returns a array of Chords available to parentTuning
    /// - Parameters:
    ///   - chordDictionary: dictionary of <chordName, fretIndicesString>
    ///   - parentTuning: the Tuning to which this set of Chords belongs
    /// - Returns: [Chord]
    func convertToArrayOfChords(chordDictionary: Dictionary<String, String>,
                                parentTuning: Tuning) -> [Chord] {
        @Query var appState: AppState
        var chords: [Chord] = []
        
        for entry in chordDictionary {
            let chord = Chord(parentChordGroup: (appState.activeTuning?.activeChordGroup)!)
            chord.name = entry.key
            chord.fretMap = entry.value
            chords.append(chord)
        }
        
        return chords
    }
    
    /// This method builds NSMutableSet of ChordGroups for this parentTuning
    /// - Parameters:
    ///   - dict: [String: String]  dictionary of [ChordGroup.name, chordNamesString] which are used to build returned chordGroupsSet
    ///   - parentTuning: the parentTuning to which this group belongs
    /// - Returns: NSMutableSet of ChordGroups managed Objects
    func convertToArrayOfChordGroups(dict: Dictionary<String,String>,
                                     parentTuning: Tuning) -> [ChordGroup] {
        var chordGroups: [ChordGroup] = []
        var activeChordGroupIsSet = false
        
        for entry in dict {
            // create new ChordGroupd
            var chordGroup = ChordGroup()
            chordGroup.name = entry.key
            chordGroup.availableChordNames = (entry.value).components(separatedBy: "-")
            chordGroup.availableChords = getGroupsChords(chordGroup: chordGroup,
                                                         parentTuning: parentTuning)
            chordGroup.parentTuning = parentTuning
            if activeChordGroupIsSet == false {
                parentTuning.activeChordGroup = chordGroup
                activeChordGroupIsSet = true
            }
            chordGroups.append(chordGroup)
        }
        
        return chordGroups
    }
    
    /// This method builds a NSMutableSet of chordGroups available Chords
    /// - Parameters:
    ///   - chordGroup: Optional ChordGroup
    ///   - parentTuning: Optional Tuning to which this group belongs
    /// - Returns: array of Chords
    func getGroupsChords(chordGroup: ChordGroup?,
                         parentTuning: Tuning?) -> [Chord] {
        var thisGroupsChords: [Chord] = []
        var activeChordIsSet = false
        if let chordNames = chordGroup?.availableChordNames {
            for chordName in chordNames {
                if let chord = getChord(name: chordName,
                                        parentTuning: parentTuning) {
                    thisGroupsChords.append(chord)
                    
                    if activeChordIsSet == false {
                        chordGroup?.activeChord = chord
                        activeChordIsSet = true
                    }
                }
            }
        }
        
        return thisGroupsChords
    }
    
    /// This method returns the Chord specified by name for the parentTuning
    /// - Parameters:
    ///   - name: name of the chord in this Tuning
    ///   - parentTuning: the Tuning to which this chord belongs
    /// - Returns: Chord specified by name in parentTuning
    func getChord(name: String,
                  parentTuning: Tuning?) -> Chord? {
        if let chordArray: [Chord] = parentTuning?.chords as? [Chord] {
            for chord in chordArray {
                if chord.name == name {
                    return chord
                }
            }
        }
        
        return nil
    }
}

enum PlistError: Error {
    case badChordGroupsLibraryAddress
    case badChordLibraryAddress
    case unknownError
}
