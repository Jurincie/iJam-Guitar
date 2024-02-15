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
    var activeChord: Chord? = nil
    var availableChordNames: String = ""
    
    // Relationships
    @Relationship(deleteRule: .cascade) var availableChords: [Chord] {
        didSet {
            Logger.viewCycle.log("availableChords CHANGED")
        }
    }
    
    init(name: String = "", 
         activeChord: Chord? = nil,
         availableChords: [Chord] = []) {
        self.name = name
        self.activeChord = activeChord
        self.availableChords = availableChords
    }
    
    func getAvailableChordNames() -> [String] {
        availableChordNames.components(separatedBy: "-")
    }
}
