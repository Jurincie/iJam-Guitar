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
final class Tuning {
    // Stored Properties
    @Attribute(.unique) var name: String?
    var openNoteIndices: String
    var stringNoteNames: String
    var chordsDictionary = [String:String]()
    var activeChordGroup: ChordGroup? = nil
    
    // Relationship
    @Relationship(deleteRule: .cascade) var chordGroups: [ChordGroup]
    
    init(name: String? = nil,
         openNoteIndices: String = "",
         stringNoteNames: String = "",
         chordGroups: [ChordGroup] = []) {
        self.name = name
        self.openNoteIndices = openNoteIndices
        self.stringNoteNames = stringNoteNames
        self.chordGroups = chordGroups
    }
}

extension Tuning: Equatable {
    static func == (lhs: Tuning, rhs: Tuning) -> Bool {
        lhs.name == rhs.name
    }
}

extension Tuning: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine([name, openNoteIndices, stringNoteNames])
    }
}
