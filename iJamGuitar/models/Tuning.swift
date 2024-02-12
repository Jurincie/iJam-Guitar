//
//  Tuning.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 12/2/23.
//
//

import Foundation
import SwiftData
 
@Model
final class Tuning: Hashable {
    @Attribute(.unique) var name: String?
    var openNoteIndices: String
    var stringNoteNames: String
    var activeChordGroup: ChordGroup? = nil
    
    // Relationships
    @Relationship(deleteRule: .cascade)
    var chordGroups = [ChordGroup]()
    @Relationship(deleteRule: .cascade)
    var chords = [Chord]()
    
    init(name: String? = nil,
         openNoteIndices: String = "",
         stringNoteNames: String = "") {
        self.name = name
        self.openNoteIndices = openNoteIndices
        self.stringNoteNames = stringNoteNames
    }
    
    static func == (lhs: Tuning, rhs: Tuning) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine([name, openNoteIndices, stringNoteNames])
    }
}
