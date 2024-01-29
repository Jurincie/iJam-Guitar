//
//  Tuning.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 12/2/23.
//
//

import Foundation
import SwiftData
 
class Tuning: Hashable {
    static func == (lhs: Tuning, rhs: Tuning) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    @Attribute(.unique) var name: String = ""
    var openNoteIndices: String = ""
    var stringNoteNames: String = ""
    var activeChordGroup: ChordGroup?
    var chordGroups: [ChordGroup] = []
    var chords: [Chord] = []
    
    init() {}
}
