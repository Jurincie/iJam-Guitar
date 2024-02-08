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
class ChordGroup {
    var availableChordNames: [String] {
        get {
            availableChords.map() {
                $0.name ?? ""
            }
        }
        set {}
    }
    var name: String = ""
    @Relationship var activeChord: Chord?
    @Relationship(deleteRule: .cascade) var availableChords: [Chord] = []
    @Relationship(inverse: \Tuning.chordGroups)
    var parentTuning: Tuning?
    
    init(name: String = "",
         activeChord: Chord? = nil,
         tuning: Tuning? = nil) {
        self.name = name
        self.activeChord = activeChord
        self.availableChords = []
        self.parentTuning = tuning
    }
}
