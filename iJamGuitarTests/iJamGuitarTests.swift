//
//  iJamGuitarTests.swift
//  iJamGuitarTests
//
//  Created by Ron Jurincie on 12/5/23.
//

import AVFAudio
import SwiftData
import SwiftUI
import XCTest

@testable import iJamGuitar

@available(iOS 17.0, *)
final class iJamViewModelTests: XCTestCase {
    // Given
    @Query var appStates: [AppState]
    let tooBig = 20
    
    func test_iJamViewModel_getAvailableChordNames_returnsArrayOfTenStrings() {
            
        // Then:
//        XCTAssertEqual(chordNameArray.count, 10)
    }
   
    func test_iJamAudioManager_noteNamesArray_shouldHaveFortyFourElements() {
//        let audioManager = iJamAudioManager(appState: appStates.first!)
        
        // Then
//        XCTAssertEqual(audioManager.noteNamesArray.count, 43)
    }
    
    func test_iJamModel_Tunings_ChordsMeetRequirements() {
//        if let tunings = Array(appState.tunings) as? [Tuning] {
//            for tuning in tunings {
//                for chord in tuning.chords {
//                    let meetsRequirements = doesChordMeetRequirements(chord)
//                    XCTAssertEqual(meetsRequirements, true)
//                }
//            }
//        }
    }
        
    func test_iJamAudioManager_formerZone_shouldInitializeToNegativeOne () {
//        // When
//        let audioManager = iJamAudioManager()
//        let zone = audioManager.formerZone
//        
//        // Then
//        XCTAssertEqual(zone, -1)
    }
    
    func test_iJamAudioManager_audioPlayerArray_ShouldHaveSixAudioPlayers() {
//        // When
//        let audioManager = iJamAudioManager()
//        XCTAssertNotNil(audioManager.audioPlayerArray)
//        XCTAssertEqual(audioManager.audioPlayerArray.count, 6)
//        
//        // Then
//        var thisAudioPlayer: AVAudioPlayer?
//        
//        for _ in 0...30 {
//            thisAudioPlayer = audioManager.audioPlayerArray[Int.random(in: 0..<6)]
//            XCTAssertTrue(((thisAudioPlayer?.isKind(of: AVAudioPlayer.self)) != nil))
//        }
    }
    
    func test_iJamAudioManager_thisZone_shouldInitializeToNegativeOne () {
        // When
//        let audioManager = iJamAudioManager()
//        let zone = audioManager.formerZone
//
//        // Then
//        XCTAssertEqual(zone, -1)
    }
    
//    func getSpan(fretMap: String) -> Int {
//        var maxFret: Int = 0
//        var minFret: Int = tooBig
//        
//        for char in fretMap {
//            if char != "x" && char != "0" {
//                let fret = viewModel.getFretFromChar(char)
//                maxFret = max(maxFret, fret)
//                minFret = min(minFret, fret)
//            }
//        }
//        
//        let span = minFret >= tooBig ? maxFret : maxFret - minFret
//        
//        return span
//    }
    
//    func doesChordMeetRequirements(_ chord: Chord) -> Bool {
//        if chord.fretMap?.count != 6 {
//            return false
//        }
//        let span = getSpan(fretMap: chord.fretMap ?? "111111")
//        if span < 0 || span > 5 {
//            return false
//        }
//    
//        return true
//    }
}
