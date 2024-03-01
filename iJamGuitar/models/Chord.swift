//
//  Chord.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 12/2/23.
//
//

import Foundation
import SwiftData
import OSLog

@Model
final class Chord {
    // Stored Properties
    var name: String
    var fretMapString: String = ""
    
    // Relationship
    @Relationship(inverse: \ChordGroup.availableChords) var chordGroup: ChordGroup?
    @Relationship(inverse: \ChordGroup.activeChord) var group: ChordGroup?
    
    init(name: String,
         fretMapString: String) {
        self.name = name
        self.fretMapString = fretMapString
    }
}

extension Chord: Hashable {}
extension Chord: Equatable {}

extension Chord: Comparable {
    static func < (lhs: Chord, rhs: Chord) -> Bool {
        lhs.name < rhs.name
    }
}

extension Chord: CustomStringConvertible {
    var description: String {
        return "name: " + name + "  FretMap: " + fretMapString
    }
}
    
        
