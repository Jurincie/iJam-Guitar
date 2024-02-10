//
//  iJamGuitarTests.swift
//  iJamGuitarTests
//
//  Created by Ron Jurincie on 12/5/23.
//

import XCTest
import SwiftUI
import AVFAudio

@testable import iJamGuitar

final class iJamViewModelTests: XCTestCase {
    // Given
    let model = iJamViewModel()
    let tooBig = 20

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
    
    func test_iJamViewModel_getAvailableChordNames_returnsArrayOfTenStrings() {
        // When:
        let chordNameArray: [String] = model.getAvailableChordNames(activeChordGroup: model.activeChordGroup)
            
        // Then:
        XCTAssertEqual(chordNameArray.count, 10)
    }
   
    func test_iJamAudioManager_noteNamesArray_shouldHaveFortyFourElements() {
        let audioManager = iJamAudioManager(model: model)
        
        // Then
        XCTAssertEqual(audioManager.noteNamesArray.count, 43)
    }
    
    func test_iJamModel_Tunings_ChordsMeetRequirements() {
        if let tunings = Array(model.tunings) as? [Tuning] {
            for tuning in tunings {
                for chord in tuning.chords {
                    let meetsRequirements = doesChordMeetRequirements(chord)
                    XCTAssertEqual(meetsRequirements, true)
                }
            }
        }
    }
        
    func test_iJamAudioManager_formerZone_shouldInitializeToNegativeOne () {
        // When
        let audioManager = iJamAudioManager(model: model)
        let zone = audioManager.formerZone
        
        // Then
        XCTAssertEqual(zone, -1)
    }
    
    func test_iJamAudioManager_audioPlayerArray_ShouldHaveSixAudioPlayers() {
        // When
        let audioManager = iJamAudioManager(model: model)
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
        let audioManager = iJamAudioManager(model: model)
        let zone = audioManager.formerZone

        // Then
        XCTAssertEqual(zone, -1)
    }
    
    func getSpan(fretMap: String) -> Int {
        var maxFret: Int = 0
        var minFret: Int = tooBig
        
        for char in fretMap {
            if char != "x" && char != "0" {
                let fret = model.getFretFromChar(char)
                maxFret = max(maxFret, fret)
                minFret = min(minFret, fret)
            }
        }
        
        let span = minFret >= tooBig ? maxFret : maxFret - minFret
        
        return span
    }
    
    func doesChordMeetRequirements(_ chord: Chord) -> Bool {
        if chord.fretMap?.count != 6 {
            return false
        }
        let span = getSpan(fretMap: chord.fretMap ?? "111111")
        if span < 0 || span > 5 {
            return false
        }
    
        return true
    }
}
