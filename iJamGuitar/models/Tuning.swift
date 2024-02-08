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
class Tuning: Hashable {
    @Attribute(.unique) var name: String?
    var openNoteIndices: String
    var stringNoteNames: String
    @Relationship(deleteRule: .cascade) var activeChordGroup: ChordGroup?
    @Relationship(deleteRule: .cascade) var chordGroups: [ChordGroup] = []
    @Relationship var chords: [Chord] = []
    
    init(name: String? = nil,
         openNoteIndices: String = "",
         stringNoteNames: String = "",
         activeChordGroup: ChordGroup? = nil,
         chordGroups: [ChordGroup] = [],
         chords: [Chord] = []) {
        self.name = name
        self.openNoteIndices = openNoteIndices
        self.stringNoteNames = stringNoteNames
        self.activeChordGroup = activeChordGroup
        self.chordGroups = chordGroups
        self.chords = chords
    }
    
    static func == (lhs: Tuning, rhs: Tuning) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine([name, openNoteIndices, stringNoteNames])
    }
}
