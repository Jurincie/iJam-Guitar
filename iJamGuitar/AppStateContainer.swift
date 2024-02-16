//
//  AppStateContainer.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 2/11/24.
//

import Foundation
import OSLog
import SwiftData

actor AppStateContainer {
    @MainActor
    static func create(_ shouldCreateDefaults: Bool) -> ModelContainer {
        let schema = Schema([AppState.self, ChordGroup.self, Chord.self, Tuning.self])
        let configuration = ModelConfiguration()
        var container: ModelContainer
        
        do {
            container = try ModelContainer(for: schema,
                                           configurations: configuration)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        
        if shouldCreateDefaults {
            do {
                try populateData()
            } catch {
                print("FOUND ERROR")
            }
            
            UserDefaults.standard.setValue(true, forKey: "DataExists")
        }
            
        return container
        
        func populateData() throws {
            // THIS is the ONLY insert we need
            // as we are preloading our data
            let appState = AppState()
            container.mainContext.insert(appState)
            
            do {
                appState.tunings = try createTuningsFromPlists()
            } catch {
                throw PlistError.unknownError
            }
            appState.activeTuning = appState.tunings?.first(where: { chordGroup in
                chordGroup.name == "Standard"
            })
            appState.activeTuning?.activeChordGroup = appState.activeTuning?.chordGroups.first
            appState.capoPosition = 0
            appState.pickerTuningName = appState.activeTuning?.name ?? ""
            appState.pickerChordGroupName = appState.activeChordGroup?.name ?? ""
            appState.selectedChordIndex = getSelectedChordIndex(appState: appState)
            appState.currentFretIndexMap = appState.getFretIndexMap(chord: appState.activeChordGroup?.activeChord)
        }
        
        func getSelectedChordIndex(appState: AppState) -> Int {
            var chordIndex = 0
            
            if let availableChords = appState.activeChordGroup?.availableChords  {
                for chord in availableChords {
                    if chord == appState.activeTuning?.activeChordGroup?.activeChord {
                        break
                    }
                    chordIndex += 1
                }
                chordIndex = min(availableChords.count - 1, appState.selectedChordIndex)
            }
            
            return chordIndex
        }
        
        /// This method sets all needed values for Tuning identified by tuningName
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
            
            tuning.chordsDictionary = thisChordGroupChordDictionary
            
            guard let path = Bundle.main.path(forResource: chordGroupsPath, ofType: "plist"),
                  let thisChordGroupsDict = NSDictionary(contentsOfFile: path) as? [String: String]  else {
                throw PlistError.badChordLibraryAddress
            }
            
            let chordGroups: [ChordGroup] = convertToArrayOfChordGroups(dict: thisChordGroupsDict, 
                                                                        parentTuning: tuning)
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
        func createTuningsFromPlists() throws -> [Tuning] {
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
            
            return [standardTuning, dropDTuning, openDTuning]
        }
        
        /// Creates and returns a array of Chords available to parentTuning
        /// - Parameters:
        ///   - chordDictionary: dictionary of <chordName, fretIndicesString>
        ///   - parentTuning: the Tuning to which this set of Chords belongs
        /// - Returns: [Chord]
        func convertToArrayOfChords(chordString: String,
                                    chordDictionary: Dictionary<String, String>,
                                    parentTuning: Tuning) -> [Chord] {
            var chords = [Chord]()
            
            for entry in chordDictionary {
                let chord = Chord(name: entry.key, fretMapString: entry.value)
                chords.append(chord)
            }
            
            return chords
        }
        
        /// This method builds an Array of ChordGroups
        /// - Parameters:
        ///   - dict: [String: String]  dictionary of [ChordGroup.name, chordNamesString]
        ///             which are used to build returned chordGroupsSet
        ///   - parentTuning: the parentTuning to which this group belongs
        /// - Returns: Array of ChordGroups
        func convertToArrayOfChordGroups(dict: Dictionary<String,String>,
                                         parentTuning: Tuning) -> [ChordGroup] {
            var chordGroups: [ChordGroup] = []
            
            for entry in dict {
                // create new ChordGroupd
                let chordGroup = ChordGroup()
                chordGroup.name = entry.key
                let chordNames = entry.value
                chordGroup.availableChordNames  = chordNames
                chordGroup.availableChords = getGroupsChords(chordNames: chordNames,
                                                             parentTuning: parentTuning,
                                                             parentChordGroup: chordGroup) ?? []
                
                chordGroups.append(chordGroup)
            }
            
            parentTuning.activeChordGroup = chordGroups.first!
            
            return chordGroups
        }
        
        /// This method builds a NSMutableSet of chordGroups available Chords
        /// - Parameters:
        ///   - chordGroup: Optional ChordGroup
        ///   - parentTuning: Optional Tuning to which this group belongs
        /// - Returns: array of Chords
        func getGroupsChords(chordNames: String,
                             parentTuning: Tuning?,
                            parentChordGroup: ChordGroup) -> [Chord]? {
            guard parentTuning == parentTuning else { return [] }
            
            let chordNameArray = chordNames.components(separatedBy: "-")
            var thisGroupsChords: [Chord] = []
            var activeChordIsSet = false
           
            for chordName in chordNameArray {
                if let chord = getChord(chordName: chordName,
                                        chordDictionary: parentTuning!.chordsDictionary) {
                    thisGroupsChords.append(chord)
                    
                    if activeChordIsSet == false {
                        parentChordGroup.activeChord = chord
                        activeChordIsSet = true
                    }
                }
            }
            
            return thisGroupsChords
        }
        
        /// This method returns the Chord specified by name for the parentTuning.chordDictionary
        /// - Parameters:
        ///   - name: name of the chord in this Tuning
        ///   - chordDictionary: the ChordDict in parentTuning
        /// - Returns: Chord specified by chordNamesString
        func getChord(chordName: String,
                      chordDictionary: Dictionary<String, String>) -> Chord? {
            let entry = chordDictionary.first { (key: String, value: String) in
                chordName == key
            }
            
            if let entry = entry {
                let newChord = Chord(name: entry.key, fretMapString: entry.value)
            
                return newChord
            }
            
            return nil
        }
    }
}

