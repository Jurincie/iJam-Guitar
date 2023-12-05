//
//  Chord.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 12/2/23.
//
//

import Foundation
import SwiftData

class Chord: Equatable {
    static func == (lhs: Chord, rhs: Chord) -> Bool {
        lhs.name == rhs.name && lhs.fretMap == rhs.fretMap
    }
    
    var fretMap: String?
    var name: String?
    var activeChord: ChordGroup?
    var tuning: Tuning?
    
    init() {
    }
}
