//
//  AppStateContainer.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 2/11/24.
//

import Foundation
import OSLog
import SwiftUI
import SwiftData

actor AppStateContainer {
    @MainActor
    static func create(_ shouldCreateDefaults: Bool) -> ModelContainer {
        let schema = Schema([AppState.self])
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
            let appState = AppState()
            
            defer {
                // THIS is the ONLY insert we need
                // as we are preloading our data
                container.mainContext.insert(appState)
            }
            
            // Standard Tuning
            let standardTuning = Tuning()
            do {
                try setupTuning(tuning: standardTuning,
                                tuningName: "Standard",
                                openIndices: "4-9-14-19-23-28",
                                noteNames: "E-A-D-G-B-E",
                                chordLibraryFileName: "StandardTuning_ChordLibrary",
                                chordGroupsFileName: "StandardTuningChordGroups")
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
                                chordLibraryFileName: "DropD_ChordLibrary",
                                chordGroupsFileName: "DropDTuningChordGroups")
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
                                chordLibraryFileName: "OpenD_ChordLibrary",
                                chordGroupsFileName: "OpenDTuningChordGroups")
            } catch {
                throw PlistError.unknownError
            }
            
            // Open G Tuning
            let openGTuning = Tuning()
            do {
                try setupTuning(tuning: openGTuning,
                                tuningName: "Open G",
                                openIndices: "2-7-14-19-23-26",
                                noteNames: "D-G-D-G-B-D",
                                chordLibraryFileName: "OpenG_ChordLibrary",
                                chordGroupsFileName: "OpenGTuningChordGroups")
            } catch {
                throw PlistError.unknownError
            }
            
            appState.activeTuning = standardTuning
            appState.tunings.append(contentsOf: [standardTuning, dropDTuning, openDTuning, openGTuning])
            appState.pickerTuningName = appState.activeTuning?.name ?? ""
            appState.pickerChordGroupName = appState.activeChordGroup?.name ?? ""
            appState.currentFretIndexMap = [-1, 3, 2, 0, 1, 0]
        }
        
        /// This method sets all needed values for Tuning identified by tuningName
        /// It should ONLY be callled on the initial launch to build the appState from iJamDataModel.xcaDataModel,
        /// which is then used by iJamModel.
        /// - Parameters:
        ///   - tuning: newly instantiated Tuning
        ///   - tuningName: name of this Tuning
        ///   - openIndices: represents each Strings (open position)  index into the noteNames Array
        ///   - noteNames: noteNames is an array of the noteNames
        ///   - chordLibraryFileName: pathName for this Tuning's chords Dictionary
        ///   - chordGroupsFileName: pathName for this Tuning's chordGroups Dictionary
        func setupTuning(tuning: Tuning,
                         tuningName: String,
                         openIndices: String,
                         noteNames: String,
                         chordLibraryFileName: String,
                         chordGroupsFileName: String) throws {
            tuning.name = tuningName
            tuning.openNoteIndices = openIndices
            tuning.stringNoteNames = noteNames
            
            guard let path = Bundle.main.path(forResource: chordLibraryFileName, ofType: "plist"),
                  let thisChordGroupChordDictionary = NSDictionary(contentsOfFile: path) as? [String: String]  else {
                throw PlistError.badChordLibraryAddress
            }
            tuning.chordsDictionary = thisChordGroupChordDictionary
            
            guard let path = Bundle.main.path(forResource: chordGroupsFileName, ofType: "plist"),
                  let thisChordGroupsDict = NSDictionary(contentsOfFile: path) as? [String: String]  else {
                throw PlistError.badChordLibraryAddress
            }
            
            let chordGroups: [ChordGroup] = convertToArrayOfChordGroups(dict: thisChordGroupsDict, 
                                                                        parentTuning: tuning)
            tuning.chordGroups.append(contentsOf: chordGroups)
            Logger.statistics.info("New tuning added")
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
                var chordNames = entry.value
                chordGroup.availableChordNames = chordNames
                chordGroup.name = entry.key
                
                let chordNameArray = chordNames.components(separatedBy: "-")
                // append "NoChord" with inactivePickImage for remaing of 10
                for _ in chordNameArray.count..<10 {
                    chordNames.append("NoChord")
                }
                let availableChordsArray = chordNameArray.map({ chordName in
                    createChord(chordName: chordName,
                                chordDictionary: parentTuning.chordsDictionary)
                })
                
                // set activeChord for this group
                if chordGroup.name == "Key of C" {
                    if let activeChord = availableChordsArray.first(where: { chord in
                        chord.name == "C"
                    }) {
                        activeChord.group = chordGroup
                    }
                } else {
                    if let activeChord = availableChordsArray.first {
                        activeChord.group = chordGroup
                    }
                }
                
                // fill availableChords
                chordGroup.availableChords.append(contentsOf: availableChordsArray)
                
                chordGroups.append(chordGroup)
            }
            
            if parentTuning.name == "Standard" {
                parentTuning.activeChordGroup = chordGroups.first(where: { chordGroup in
                    chordGroup.name == "Key of C" })
            } else if parentTuning.name == "Drop D" {
                parentTuning.activeChordGroup = chordGroups.first
            }
        
            return chordGroups
        }
        
        /// This method returns the Chord specified by name for the parentTuning.chordDictionary
        /// - Parameters:
        ///   - name: name of the chord in this Tuning
        ///   - chordDictionary: the ChordDict in parentTuning
        /// - Returns: Chord specified by chordNamesString
        func createChord(chordName: String,
                      chordDictionary: Dictionary<String, String>) -> Chord {
            if chordName == "NoChord" {
                return Chord(name: "NoChord", fretMapString: "xxxxxx")
            } else {
                let entry = chordDictionary.first { (key: String, value: String) in
                    chordName == key
                }
                
                if let entry = entry {
                    return Chord(name: entry.key, fretMapString: entry.value)
                } else {
                    return Chord(name: "NoChord", fretMapString: "xxxxxx")
                }
            }
        }
    }
}

