//
//  ChordGroup.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 12/2/23.
//
//

import Foundation
import SwiftData

class ChordGroup {
    var availableChordNames: String = ""
    var name: String = ""
    @Relationship(inverse: \Chord.activeChord)
    var activeChord: Chord?
    var availableChords: [Chord] = []
    @Relationship(inverse: \Tuning.activeChordGroup)
    var tuning: Tuning?

    init() {
    }
}
