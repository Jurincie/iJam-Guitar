//
//  iJam_SwiftTest.swift
//  iJamGuitarTests
//
//  Created by Ron Jurincie on 7/13/24.
//

import Testing
@testable import iJamGuitar

struct iJam_SwiftTest {
    var appState = AppState()
    
    @Test 
    func getFretFromCharWorksForAllCases() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        // Given
        let characters: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
        let enumeratedCharacters = characters.enumerated()
        
        // When
        for pair in enumeratedCharacters {
            // Then
            #expect(pair.0 == appState.getFretFromChar(pair.1))
        }
    }
}
