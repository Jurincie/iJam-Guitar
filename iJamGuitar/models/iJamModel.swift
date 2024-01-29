//
//  iJamModel.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/24/23.
//

import SwiftUI
import SwiftData
import AVFAudio
import OSLog

@Observable
final class iJamModel {
    static let shared = iJamModel()
    let kDefaultVolume = 5.0
    var showVolumeAlert = false
    var showAudioPlayerInUseAlert = false
    var showAudioNotAvailableAlert: Bool = false
    var showAudioPlayerErrorAlert = false
    var activeTuning: Tuning?
    var tunings: [Tuning] = []
    var capoPosition: Int = 0
    var activeChordGroup: ChordGroup?
    var isMuted = false
    var volumeLevel = 5.0
    var selectedChordIndex: Int = 0
    var savedVolumeLevel = 5.0
    var fretIndexMap: [Int] = []
    var minimumFret: Int = 0
    var availableChords: [Chord] = []
    var activeTuningName: String = "" {
        didSet {
            if let newTuning = getTuning(name: activeTuningName) {
                makeNewTuningActive(newTuning: newTuning)
            }
        }
    }
    var activeChordGroupName: String = ""
    {
        didSet {
            if let newChordGroup = getChordGroup(name: activeChordGroupName) {
                setActiveChordGroup(newChordGroup: newChordGroup)
            }
        }
    }
    var activeChord: Chord? {
        didSet {
            activeTuning?.activeChordGroup?.activeChord = activeChord
            fretIndexMap = getFretIndexMap(chord: activeChord)
            minimumFret = getMinimumDisplayedFret()
        }
    }
        
    init() {
        if tunings.count == 0 {
            try? loadDataModelFromPLists()
        }
        
        setupModel()
        
        // if another app is using AudioPlayer -> show alert
        showAudioNotAvailableAlert = AVAudioSession.sharedInstance().isOtherAudioPlaying
    }
}

extension iJamModel {
    private func setupModel() {
        availableChords = getAvailableChords(activeChordGroup: activeTuning?.activeChordGroup, activeTuning: activeTuning)
        fretIndexMap = getFretIndexMap(chord: activeTuning?.activeChordGroup?.activeChord)
        setSelectedChordIndex()
    }
    
    func setSelectedChordIndex() {
        var chordIndex = 0
        
        for chord in availableChords {
            if chord == activeTuning?.activeChordGroup!.activeChord {
                break
            }
            chordIndex += 1
        }
        chordIndex = min(availableChords.count - 1, selectedChordIndex)
        
        selectedChordIndex = chordIndex
    }
    
    /// This method sets all needed values for Tuning identified by tuningName
    /// and adds the new compled Tuning to the
    /// It should ONLY be callled on the initial launch to build the appState from iJamDataModel.xcaDataModel,
    /// which is then used by iJamModel.
    /// - Parameters:
    ///   - appState: appState @Model
    ///   - tuning: tuning from appState
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
        tunings.append(tuning)
    }
    
    /// This method should ONLY be called on initial launch of app
    /// It populated the appState with tunings specified in .plist and sets initial values for:
    /// capoPosition
    /// isMuted
    /// volumeLevel
    /// activeTuning
    /// eachTunings activeChordGroup
    /// each chordGroups activeChord
    func loadDataModelFromPLists() throws { // populate our initial dataModel from Plists
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
        
        
        // remainder of appState
        activeTuning = standardTuning
        activeChordGroup = activeTuning?.chordGroups.first
        capoPosition = 0
        isMuted = false
        volumeLevel = Double(truncating: NSDecimalNumber(value: kDefaultVolume))
        activeTuning = standardTuning
        activeTuningName = activeTuning?.name ?? "Error setting activeTuning"
    }
    
    /// Creates and returns a array of Chords available to parentTuning
    /// - Parameters:
    ///   - chordDictionary: dictionary of <chordName, fretIndicesString>
    ///   - parentTuning: the Tuning to which this set of Chords belongs
    /// - Returns: [Chord]
    func convertToArrayOfChords(chordDictionary: Dictionary<String,String>,
                                parentTuning: Tuning) -> [Chord] {
        // create a NSMutableSet of Chord managed Objects
        var chords: [Chord] = []
        
        for entry in chordDictionary {
            let chord       = Chord()
            chord.name      = entry.key
            chord.fretMap   = entry.value
            chord.tuning    = parentTuning
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
            // create new ChordGroup
            let chordGroup = ChordGroup()
            chordGroup.name                 = entry.key
            chordGroup.availableChordNames  = entry.value
            chordGroup.availableChords      = getGroupsChords(chordGroup: chordGroup, 
                                                              parentTuning: parentTuning)
            chordGroup.tuning               = parentTuning
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
        if let chordNames = chordGroup?.availableChordNames.components(separatedBy: "-") {
            for chordName in chordNames {
                if let chord = getChord(name: chordName, parentTuning: parentTuning) {
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
    func getChord(name: String, parentTuning: Tuning?) -> Chord? {
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
    case badChordGroupsLibraryAddress, badChordLibraryAddress, unknownError
}
