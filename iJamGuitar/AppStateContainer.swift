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

///  This actor enables us to pre-load data from Plists on INITIAL LAUNCH
/// - Parameter shouldCreateDefaults: Bool
/// - Returns: ModelContainer -> An object that manages an app's schema and model storage configuration.
actor
AppStateContainer {
    @MainActor
    static func create(_ shouldCreateDefaults: Bool) -> ModelContainer {
        let schema = Schema([AppState.self])
        let configuration = ModelConfiguration()
        let container: ModelContainer
        var tuningsArray = [Tuning]()
        var standardTuning: Tuning?
        
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
        
        /// Only called on INITIAL launch
        /// Builds AppState, ChordGroups, Tunings and Chords from Plists
        /// - Throws: PlistError on failure
        func populateData() throws {
            let appState = AppState()
            defer {
                // THIS is the ONLY "insert" we
                // need as we preload our data
                container.mainContext.insert(appState)
            }
            
            // build models from TuningMeta.plist
             guard let path = Bundle.main.path(forResource: "TuningMeta", ofType: "plist") else { return }
            
             if let dictionaries: [Dictionary<String,String>] = NSArray(contentsOfFile: path)  as? [Dictionary<String, String>] {
                 // iterate arrayOfdictionaries
                 for dict in dictionaries {
                     guard let tuningName = dict["TuningName"],
                           let openNoteIndices = dict["OpenNoteIndices"],
                           let noteNames = dict["NoteNames"],
                           let chordLibraryFileName = dict["ChordLibraryName"],
                           let chordGroupsFileName = dict["ChordGroupName"] else {
                         throw PlistError.unknownError
                     }
                     do {
                         let newTuning = try createTuning(tuningName: tuningName,
                                                          openIndices: openNoteIndices,
                                                          noteNames: noteNames,
                                                          chordLibraryFileName: chordLibraryFileName,
                                                          chordGroupsFileName: chordGroupsFileName)
                         if newTuning.name == "Standard" {
                             standardTuning = newTuning
                         }
                         tuningsArray.append(newTuning)
                     } catch {
                         throw PlistError.unknownError
                     }
                 }
             }
            
            //  activeChordGroup.activeChord is set to a C chord:
            //  activeChordGroup to be "Key of C" AND activeChord to be "C"
            //  on INITIAL launch
            //  If this ever changes --> make provsions
            appState.tunings = tuningsArray
            appState.pickerTuningName = appState.activeTuning?.name ?? ""
            appState.pickerChordGroupName = appState.activeChordGroup?.name ?? ""
            appState.activeTuning = standardTuning
            appState.pickerTuningName = "Standard"
            appState.pickerChordGroupName = "Key of C"
            appState.currentFretPositions = [-1, 3, 2, 0, 1, 0]
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
        func createTuning(tuningName: String,
                          openIndices: String,
                          noteNames: String,
                          chordLibraryFileName: String,
                          chordGroupsFileName: String) throws -> Tuning {
            let newTuning = Tuning()
            newTuning.name = tuningName
            newTuning.openNoteIndices = openIndices
            newTuning.stringNoteNames = noteNames
            
            guard let path = Bundle.main.path(forResource: chordLibraryFileName, ofType: "plist"),
                  let thisChordGroupChordDictionary = NSDictionary(contentsOfFile: path) as? [String: String]  else {
                throw PlistError.badChordLibraryAddress
            }
            newTuning.chordsDictionary = thisChordGroupChordDictionary
            
            guard let path = Bundle.main.path(forResource: chordGroupsFileName, ofType: "plist"),
                  let thisChordGroupsDict = NSDictionary(contentsOfFile: path) as? [String: String]  else {
                throw PlistError.badChordGroupAddress
            }
            
            let chordGroups: [ChordGroup] = convertToArrayOfChordGroups(dict: thisChordGroupsDict,
                                                                        parentTuning: newTuning)
            newTuning.chordGroups.append(contentsOf: chordGroups)
           
            Logger.statistics.info("New tuning added")
            
            return newTuning
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
                                chordDictionary: parentTuning.chordsDictionary)!
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
            } else {
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
                         chordDictionary: Dictionary<String, String>) -> Chord? {
            var newChord: Chord?
            
            if chordName == "NoChord" {
                newChord = Chord(name: "NoChord", fretMapString: "xxxxxx")
            } else {
                let entry = chordDictionary.first { (key: String, value: String) in
                    chordName == key
                }
                
                if let entry = entry {
                    newChord = Chord(name: entry.key, fretMapString: entry.value)
                }
            }
            return newChord
        }
    }
}

