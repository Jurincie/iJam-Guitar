//
//  Chord.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 12/2/23.
//
//

import Foundation
import SwiftData

@Model
final class Chord: Equatable {
    var fretMap: String?
    @Attribute(.unique) var name: String?
    @Relationship(inverse: \ChordGroup.self)
    @Relationship(inverse: \Tuning.self)
    var parentChordGroup: ChordGroup
   
    init(parentChordGroup: ChordGroup,
         fretMap: String? = nil,
         name: String? = nil) {
        self.fretMap = fretMap
        self.name = name
        self.parentChordGroup = parentChordGroup
    }
   
    static func == (lhs: Chord, rhs: Chord) -> Bool {
        lhs.name == rhs.name && lhs.fretMap == rhs.fretMap
    }
}
    
        
