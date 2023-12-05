//
//  IJamGuitarViewModelExtension.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/2/23.
//

import Foundation

extension iJamModel
{
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
   
    
    /// - Parameter newTuning: newTuning
    /// /// Description: When user selects NEW Tuning, we need to set:
    /// /// activeTuning, activeChordGroup, activeChordGroupName and availableChords
    /// /// fretIndexMap and selectedIndex based on the activeChord for this Tuning
    /// /// Warning: Must set activeChordGroup prior to setting activeChordGroupName
    func makeNewTuningActive(newTuning: Tuning) {
        guard newTuning.activeChordGroup != nil else { return }
        
        activeTuning = newTuning
        activeChordGroup = activeTuning?.activeChordGroup
        activeChordGroupName = activeChordGroup?.name ?? ""
        activeTuning?.activeChordGroup = newTuning.activeChordGroup
        availableChords = getAvailableChords(activeChordGroup: activeChordGroup, activeTuning: activeTuning)
        fretIndexMap = getFretIndexMap(chord: activeChordGroup?.activeChord)
        selectedChordIndex = getSelectedChordButtonIndex()
    }
    
    ///  This method instantiates and returns a new ChordGroup based upon the name parameter.
    ///     if no such ChordGroup with that name exists, this method returns nil
    /// - Parameter name: name-> The name selected by user in ChordGroup Picker
    /// - Returns: Optional(ChordGroup)
    func getChordGroup(name: String) -> ChordGroup? {
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
    
    ///  This method sets the newly instantiated newChordGroup as the activeChordGroup.
    ///  Then sets the availableChords to the chords associated with this newChordGroup.
    ///  Then sets the activeChord to the newChordGroup.activeChord
    ///  Then sets the selectedIndex via getSelectedChordButtonIndex()
    ///  Then saves the context.
    /// - Parameter newChordGroup: a recently instantiated newChordGroup
    func setActiveChordGroup(newChordGroup: ChordGroup) {
        activeChordGroup = newChordGroup
        availableChords = getAvailableChords(activeChordGroup: newChordGroup, activeTuning: activeTuning)
        activeTuning?.activeChordGroup = newChordGroup
        activeChord = newChordGroup.activeChord
        selectedChordIndex = getSelectedChordButtonIndex()
    }
    
    /// This method returns an array of names associated with available Tunings
    /// - Returns: an Array of Strings containing the names of the available Tunings.
    func getTuningNames() -> [String] {
        var tuningNames: [String] = []
        for tuning in tunings {
            tuningNames.append(tuning.name)
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
        if let activeChord = activeChord,
           let activeChordIndex = availableChords.firstIndex(of: activeChord) {
            return activeChordIndex
        }
        return 0
    }
    
    // Must acccept both: "xx0212" "9ABCAA" and "320003"
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
        if let fretMap = chord?.fretMap {
            for char in fretMap {
                fretsArray.append(getFretFromChar(char))
            }
        }
        return fretsArray
    }
    
    /// Gets chord names for this chordGroup
    /// - Parameter activeChordGroup: the currently active chordGroup
    /// - Returns: array of chord names associated with activeChordGroup argument
    func getAvailableChordNames(activeChordGroup: ChordGroup?) -> [String] {
        if var availableChordNames: [String] = activeChordGroup?.availableChordNames.components(separatedBy: ["-"]) {
            if availableChordNames.count == 10 {
                return availableChordNames
            }
            for _ in availableChordNames.count...9 {
                availableChordNames.append("NoChord")
            }
            return availableChordNames
        }
        
        return []
    }
    
    /// Gets an array of chords that belong to the activeChordGroup in the activeTuning
    /// - Parameters:
    ///   - activeChordGroup: optional(activeChordGroup)
    ///   - activeTuning: optional(activeTuning
    /// - Returns: array of chords associated with activeChordGroup for activeTuning or empty array if anything goes wrong
    func getAvailableChords(activeChordGroup: ChordGroup?, activeTuning: Tuning?) -> [Chord] {
        var availableChords: [Chord] = []
        if let chordNames = activeChordGroup?.availableChordNames.components(separatedBy: "-"),
           let activeTuning = activeTuning {
            for chordName in chordNames {
                if let chord = getChord(name: chordName, tuning: activeTuning) {
                    availableChords.append(chord)
                }
            }
        }
        return availableChords
    }
    
    /// Gets the chord associated with the name argument for the tuning argumen
    /// - Parameters:
    ///   - name: the name of the new chord
    ///   - tuning: the activeTuning
    /// -   Returns: optional(Chord)
    ///             which is nil if no chord with name in arg #1 exists in the optional(Tuning) in arg #2
    ///             otherwise it returns the new chord for the optional(Tuning) in arg #2 if tuning exists
    func getChord(name: String, tuning: Tuning?) -> Chord? {
        if let chordArray: [Chord] = tuning?.chords {
            for chord in chordArray {
                if chord.name == name {
                    return chord
                }
            }
        }
        return nil
    }
    
    /// This function calculates and returns the lowest displayed fret above the nut for the activeChord in the activeChordGroup in the activeTuning
    /// - Returns: Int of the lowest displayed fret above the nut
    /// Note: must be > the nut Int
    func getMinimumDisplayedFret() -> Int {
        guard let fretChars = activeChord?.fretMap else { return 0 }
        var highest = 0
        var thisFretVal = 0
        
        for char in fretChars {
            switch char {
                // span does NOT include open string nor muted strings
            case "x":
                break
            case "A":
                thisFretVal = 11
            case "B":
                thisFretVal = 12
            case "C":
                thisFretVal = 13
            case "D":
                thisFretVal = 14
            default:
                if let intValue = char.wholeNumberValue {
                    thisFretVal = intValue
                } else {
                    thisFretVal = 0
                }
            }
            highest = max(highest, thisFretVal)
        }
        
        return highest < 6 ? 1 : max(1, highest - 4)
    }
}
