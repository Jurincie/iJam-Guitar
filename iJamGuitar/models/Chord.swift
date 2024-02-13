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
final class Chord: Equatable, Hashable {
    @Attribute(.unique) var name: String?
    var fretMap: String?
    
    init(name: String? = nil,
         fretMap: String? = nil) {
        self.name = name
        self.fretMap = fretMap
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine([name, fretMap])
    }
   
    static func == (lhs: Chord, rhs: Chord) -> Bool {
        lhs.name == rhs.name && lhs.fretMap == rhs.fretMap
    }
}
    
        
