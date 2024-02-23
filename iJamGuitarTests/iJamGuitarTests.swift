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
    // Given
    @Query var appStates: [AppState]
   
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
    
    func getSpan(fretMap: String) -> Int {
        var maxFret: Int = 0
        var minFret: Int = Int.max
        
        for char in fretMap {
            if char != "x" && char != "0" {
                let fret = appStates.first!.getFretFromChar(char)
                maxFret = max(maxFret, fret)
                minFret = min(minFret, fret)
            }
        }
        
        let span = minFret >= Int.max ? maxFret : maxFret - minFret
        
        return span
    }
    
    func doesChordMeetRequirements(_ chord: Chord) -> Bool {
        if chord.fretMapString.count != 6 {
            return false
        }
        let span = getSpan(fretMap: chord.fretMapString)
        if span < 0 || span > 5 {
            return false
        }
    
        return true
    }
}
