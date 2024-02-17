//
//  ChordGroup.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 12/2/23.
//
//

import Foundation
import SwiftData

@Model
final class ChordGroup {
    // Stored Properties
    var name: String
    var availableChordNames: String
    var activeChord: Chord?
    
    // Computed Properties
    var availableChordNamesArray: [String] {
        availableChordNames.components(separatedBy: "-")
    }
    
    // Relationships
    @Relationship(deleteRule: .cascade) var availableChords = [Chord]()
    
    init(name: String = "",
         availableChordNames: String = "") {
        self.name = name
        self.availableChordNames = availableChordNames
    }
    
    
}

extension ChordGroup: CustomStringConvertible {
    var description: String {
        return "name: \(name)\nactiveChord: \(String(describing: activeChord?.name))"
    }
}
