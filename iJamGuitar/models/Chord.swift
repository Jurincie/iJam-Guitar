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
final class Chord: Equatable, Hashable, CustomStringConvertible {
    @Attribute(.unique) var name: String
    var fretMapString: String = ""
    
    init(name: String,
         fretMapString: String) {
        self.name = name
        self.fretMapString = fretMapString
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine([name, fretMapString])
    }
   
    static func == (lhs: Chord, rhs: Chord) -> Bool {
        lhs.name == rhs.name && lhs.fretMapString == rhs.fretMapString
    }
    
    var description: String {
        return "name: " + name + "  FretMap: " + fretMapString
    }
    
}
    
        
