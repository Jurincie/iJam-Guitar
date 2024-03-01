//
//  iJamGuitarTests.swift
//  iJamAppStateTests
//
//  Created by Ron Jurincie on 12/5/23.
//

import AVFAudio
import SwiftData
import SwiftUI
import XCTest

@testable import iJamGuitar

@available(iOS 17.0, *)
final class iJamAppStateTests: XCTestCase {
    var appState: AppState?
    override func setUp() async throws {
        appState = AppState()
    }
    
    override func tearDown() { }
    
    func test_getTuningNames() {
        let chordGroupNamesString = appState?.tunings.reduce(into: "", { $0 += $1.name! + "-" })
        let chorGroupNamesArray = chordGroupNamesString?.components(separatedBy: "-")
        
        if let first = appState?.tunings.first {
            XCTAssertTrue(((chorGroupNamesArray?.contains(first.name ?? "xxx")) != nil))
        }
    }
    
    func test_getFretFromCharWorksForAllCases() {
        let characters: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
        let enumeratedCharacters = characters.enumerated()
        
        // Then
        // Test all legid values
        for pair in enumeratedCharacters {
            XCTAssertEqual(pair.0, appState?.getFretFromChar(pair.1))
        }
        
        // test bad values
        XCTAssertEqual(-1, appState?.getFretFromChar(Character("X")))
        XCTAssertEqual(-1, appState?.getFretFromChar(Character("#")))
        XCTAssertEqual(-1, appState?.getFretFromChar(Character("$")))
    }
    
    func test_iJamAudioManager_noteNamesArray_shouldHaveFortyThreeElements() {
        let audioManager = iJamAudioManager()
        
        // Then
        XCTAssertEqual(audioManager.noteNamesArray.count, 43)
    }
        
    func test_iJamAudioManager_formerZone_shouldInitializeToNegativeOne () {
        // When
        let stringsView = StringsView(height: 400)
        let zone = stringsView.formerZone

        // Then
        XCTAssertEqual(zone, -1)
    }
    
    func test_iJamAudioManager_audioPlayerArray_ShouldHaveSixAudioPlayers() {
        // Given
        let audioManager = iJamAudioManager()
        XCTAssertNotNil(audioManager.audioPlayerArray)
        XCTAssertEqual(audioManager.audioPlayerArray.count, 6)
        
        // Then
        var thisAudioPlayer: AVAudioPlayer?
        
        for _ in 0...30 {
            thisAudioPlayer = audioManager.audioPlayerArray[Int.random(in: 0..<6)]
            XCTAssertTrue(((thisAudioPlayer?.isKind(of: AVAudioPlayer.self)) != nil))
        }
    }
    
    func test_iJamAudioManager_thisZone_shouldInitializeToNegativeOne () {
        // When
        let stringsView = StringsView(height: 400)
        let zone = stringsView.formerZone

        // Then
        XCTAssertEqual(zone, -1)
    }
}
