//
//  AppStateExtension.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 2/12/24.
//

import SwiftData
import SwiftUI

extension AppState
{
    /// - Parameter newTuning: newTuning
    /// /// Description: When user selects NEW Tuning, we need to set:
    /// /// activeTuning, activeChordGroup, activeChordGroupName and availableChords
    /// /// fretIndexMap and selectedIndex based on the activeChord for this Tuning
    /// /// Warning: Must set activeChordGroup prior to setting activeChordGroupName
    func makeNewTuningActive(newTuning: Tuning) {
        guard newTuning.activeChordGroup != nil else { return }
        activeTuning = newTuning
        selectedChordIndex = 0
        pickerChordGroupName = activeChordGroup?.name ?? ""
        pickerTuningName = activeTuning?.name ?? ""
    }
    
    ///  This method sets the newly instantiated newChordGroup as the activeChordGroup.
    ///  Then sets the availableChords to the chords associated with this newChordGroup.
    ///  Then sets the activeChord to the newChordGroup.activeChord
    ///  Then sets the selectedIndex via getSelectedChordButtonIndex()
    /// - Parameter newChordGroup: a recently instantiated newChordGroup
    func makeNewChordGroupActive(newChordGroup: ChordGroup) {
        activeTuning?.activeChordGroup = newChordGroup
        selectedChordIndex = 0
        pickerTuningName = activeTuning?.name ?? ""
    }
    
    /// This method takes a name associated with Tunings names
    /// and returns an associated Tuning if able, otherwise is return nil
    /// - Parameter name: name-> The name selected by user in Tuning Picker
    /// - Returns:Tuning associated with Name
    func getTuning(name: String) -> Tuning? {
        var newTuning: Tuning? = nil
    
        for tuning in tunings {
            if tuning.name == name {
                newTuning = tuning
                break
            }
        }
    
        return newTuning
    }
    
    ///  This method instantiates and returns a new ChordGroup based upon the name parameter.
    ///     if no such ChordGroup with that name exists, this method returns nil
    /// - Parameter name: name-> The name selected by user in ChordGroup Picker
    /// - Returns: Optional(ChordGroup)
    func createChordGroup(name: String) -> ChordGroup? {
        var newChordGroup: ChordGroup? = nil
                
        if let chordGroups = activeTuning?.chordGroups {
            for case let chordGroup in chordGroups {
                if chordGroup.name == name {
                    newChordGroup = chordGroup
                    break
                }
            }
        }
        
        return newChordGroup
    }
    
    /// This method returns an array of names associated with available Tunings
    /// - Returns: an Array of Strings containing the names of the available Tunings.
    func getTuningNames() -> [String] {
        var tuningNames: [String] = []
    
        for tuning in tunings {
            tuningNames.append(tuning.name ?? "ERROR")
        }
        
        return tuningNames
    }
    
    /// This method returns an array of names associated with activeTuning.chordGroup.names
    /// - Returns: an Array of Strings containing the available chordGroup names for activeTuning.
    func getActiveTuningChordGroupNames() -> [String] {
        var chordGroupNames: [String] = []
        
        if let chordGroups = activeTuning?.chordGroups {
            for group in chordGroups {
                chordGroupNames.append(group.name)
            }
        }
    
        return chordGroupNames
    }
  
    func getSelectedChordButtonIndex() -> Int {
//        if let activeChord = activeChordGroup?.activeChord,
//           let activeChordIndex = activeChordGroup?.availableChords.firstIndex(of: activeChord) {
//            return activeChordIndex
//        }
        return 0
    }
    
    func getFretFromChar(_ char: Character) -> Int {
        switch char {
        case "A": return 10
        case "B": return 11
        case "C": return 12
        default: return char.wholeNumberValue ?? -1
        }
    }
    
    func getFretIndexMap(chord: Chord?) -> [Int] {
        var fretsArray : [Int] = []
        if let fretMap = chord?.fretMapString {
            for char in fretMap {
                fretsArray.append(getFretFromChar(char))
            }
        }
        return fretsArray
    }
    
    /// Gets the chord associated with the name argument for the tuning argumen
    /// - Parameters:
    ///   - name: the name of the new chord
    ///   - tuning: the activeTuning
    /// -   Returns: optional(Chord)
    ///             which is nil if no chord with name in arg #1 exists in the optional(Tuning) in arg #2
    ///             otherwise it returns the new chord for the optional(Tuning) in arg #2 if tuning exists
    func createChord(name: String, tuning: Tuning?) -> Chord? {
        if let chordDic = tuning?.chordsDictionary,
           let entry = chordDic.first(where: { (key: String, value: String) in
               name == key
           }){
            return Chord(name: entry.key,
                         fretMapString: entry.value)
        }
        
        return nil
    }
}
