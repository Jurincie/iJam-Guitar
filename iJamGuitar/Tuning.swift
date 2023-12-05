//
//  Tuning.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 12/2/23.
//
//

import Foundation
import SwiftData
 
class Tuning {
    @Attribute(.unique) var name: String = ""
    var openNoteIndices: String = ""
    var stringNoteNames: String = ""
    var activeChordGroup: ChordGroup?
    var chordGroups: [ChordGroup] = []
    var chords: [Chord] = []
    
    init() {}
}
