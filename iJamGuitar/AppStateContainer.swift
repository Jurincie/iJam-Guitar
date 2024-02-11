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
    static func create() -> ModelContainer {
        let schema = Schema([AppState.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema,
                                            configurations: configuration)

        do {
            try populateData()
        } catch {
            print("FOUND ERROR")
        }
        
        return container
        
        func populateData() throws {
            let appState = AppState()
            
            do {
               appState.tunings = try createTuningsFromPlists()
           } catch {
               throw PlistError.unknownError
           }
           appState.activeTuning = appState.tunings.first
           appState.activeTuning?.activeChordGroup = appState.activeTuning?.chordGroups.first
           appState.capoPosition = 0
           appState.isMuted = false
           appState.volumeLevel = Double(truncating: NSDecimalNumber(value: appState.kDefaultVolume))
           appState.activeTuning?.activeChordGroup?.availableChords = appState.getAvailableChords(appState.activeChordGroup,appState.activeTuning)
           appState.currentFretIndexMap = appState.getFretIndexMap(chord: appState.activeTuning?.activeChordGroup?.activeChord)
           
            setSelectedChordIndex(appState: appState)
            
            
            container.mainContext.insert(appState)
        }
        
        func setSelectedChordIndex(appState: AppState) {
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
                
            tuning.chords = convertToSetOfChords(chordDictionary: thisChordGroupChordDictionary, parentTuning: tuning)
                
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
        func convertToSetOfChords(chordDictionary: Dictionary<String, String>,
                                    parentTuning: Tuning) -> Set<Chord>{
            var chords = Set<Chord>()
            
            for entry in chordDictionary {
                let chord = Chord(parentChordGroup: (parentTuning.activeChordGroup)!)
                chord.name = entry.key
                chord.fretMap = entry.value
                chords.insert(chord)
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
            return parentTuning?.chords.first {
                $0.name == name
            }
        }
    }
}

