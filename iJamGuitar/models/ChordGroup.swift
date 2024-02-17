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
    
    // Relationships
    @Relationship(deleteRule: .cascade) var availableChords = [Chord]()
    
    init(name: String = "",
         availableChordNames: String = "") {
        self.name = name
        self.availableChordNames = availableChordNames
    }
    
    func getAvailableChordNames() -> [String] {
        availableChordNames.components(separatedBy: "-")
    }
}
