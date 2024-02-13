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
    // Calculated Property
    var availableChordNames: [String] {
        get {
            availableChords.map() {
                $0.name ?? ""
            }
        }
    }
    
    // Stored Properties
    var name: String
    var activeChord: Chord? = nil
    
    // Relationships
    @Relationship(deleteRule: .cascade) var availableChords = [Chord]()
    
    init(name: String = "") {
        self.name = name
    }
}
