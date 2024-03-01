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
    
    // Computed Property
    var availableChordNamesArray: [String] {
        availableChordNames.components(separatedBy: "-")
    }
    
    // Relationships
    @Relationship(deleteRule: .cascade) var availableChords = [Chord]()
    @Relationship(deleteRule: .nullify) var activeChord: Chord?
    
    init(name: String = "",
         availableChordNames: String = "") {
        self.availableChordNames = availableChordNames
        self.name = name
    }
}

extension ChordGroup: CustomStringConvertible {
    var description: String {
        return "name: \(name)   activeChord: \(String(describing: activeChord?.name))"
    }
}
