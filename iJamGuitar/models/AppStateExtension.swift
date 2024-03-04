//
//  AppStateExtension.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 2/12/24.
//

import Foundation
import SwiftData
import SwiftUI

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

extension AppState
{
    func fretBelongsInChord(stringNumber: Int, newFretNumber: Int) -> Bool {
        let fretForTappedFret = currentFretPositions[6 - stringNumber]
        let chordMap = getFretIndexMap(fretMapString: activeChordGroup?.activeChord?.fretMapString ?? "")
        let fretFromChordForThisString = chordMap[6 - stringNumber]
        
        return fretForTappedFret == fretFromChordForThisString
    }
    
    /// - Parameter newTuning: newTuning
    ///  Description: When user selects NEW Tuning, we need to set:
    ///  activeTuning, pickerTuningName, pickerChordGroupName
    ///  currentFretIndexMap
    func makeNewTuningActive(newTuning: Tuning) {
        // shouldn't be needed but just in case
        if newTuning.activeChordGroup == nil {
            activeTuning?.activeChordGroup = activeTuning?.chordGroups.first
        }
        activeTuning = newTuning
        pickerTuningName = newTuning.name ?? "ERROR"
        pickerChordGroupName = activeChordGroup?.name ?? ""
        currentFretPositions = getFretIndexMap(fretMapString: activeChordGroup?.activeChord?.fretMapString ?? "")
    }

    /// This method takes a name associated with Tunings names
    /// and returns an associated Tuning if able, otherwise is return nil
    /// - Parameter name: name-> The name selected by user in Tuning Picker
    /// - Returns:Tuning associated with Name
    func getTuning(name: String) -> Tuning? {
        let newTuning = tunings.first { tuning in
            tuning.name == name
        }
    
        return newTuning
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
    
    func getFretFromChar(_ char: Character) -> Int {
        switch char {
        case "A": return 10
        case "B": return 11
        case "C": return 12
        case "D": return 13
        case "E": return 14
        case "F": return 15
        default: return char.wholeNumberValue ?? -1
        }
    }
    
    func getFretIndexMap(fretMapString: String) -> [Int] {
        var fretsArray : [Int] = []
        for char in fretMapString {
            fretsArray.append(getFretFromChar(char))
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
    
    func getAvailableChords(dictionary: Dictionary<String,String>) -> [Chord] {
        var availableChords = [Chord]()
        let keys = dictionary.map{$0.key}
        let values = dictionary.map {$0.value}
        
        let keyValues = zip(keys, values).sorted { tuple1, tuple2 in
            tuple1.0 < tuple2.0
        }
        
        for entry in keyValues {
            let newChord = Chord(name: entry.0, fretMapString: entry.1)
            availableChords.append(newChord)
        }
        
        return availableChords
    }
}
