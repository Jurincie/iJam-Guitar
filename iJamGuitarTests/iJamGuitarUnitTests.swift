//
//  iJamAppStateUnitTests.swift
//  iJamAppStateTests
//
//  Created by Ron Jurincie on 12/5/23.
//

//import AVFAudio
//import SwiftData
//import XCTest
//
//@testable import iJamGuitar
//
//@available(iOS 17.0, *)
//final class iJamAppStateUnitTests: XCTestCase {
//    var appState: AppState?
//    
//    override func setUp() async throws {
//        // Given
//        appState = AppState()
//    }
//    
//    override func tearDown() {
//        appState = nil
//    }
//    
//    func test_fretIsInChordForProperSuccess() {
//        // When
//        let fretMapString = appState?.activeChordGroup?.activeChord?.fretMapString
//        
//        if  let char1 = fretMapString?[5],
//            let char2 = fretMapString?[4],
//            let firstStringFret = char1 == "x" ? -1 : char1.hexDigitValue,
//            let secondStringFret = char2 == "x" ? -1 : char2.hexDigitValue {
//            // Then
//            XCTAssertEqual(appState?.fretIsInChord(stringNumber: 1,
//                                                   newFretNumber: firstStringFret), true)
//            XCTAssertEqual(appState?.fretIsInChord(stringNumber: 2,
//                                                   newFretNumber: secondStringFret), true)
//        }
//    }
//    
//    func test_fretIsInChordForProperFailure() {
//        // When
//        let fretMapString = appState?.activeChordGroup?.activeChord?.fretMapString
//        
//        if  let char = fretMapString?[5],
//            let firstStringFret = char.hexDigitValue {
//            // Then
//            XCTAssertEqual(false, appState?.fretIsInChord(stringNumber: 1,
//                                                              newFretNumber: firstStringFret + 1))
//            
//            XCTAssertEqual(false, appState?.fretIsInChord(stringNumber: 1,
//                                                          newFretNumber: firstStringFret + 2))
//        }
//    }
//    
//    func test_getTuningNames() {
//        // When
//        let chorGroupNamesArray = appState?.tunings.map { tuning in
//            tuning.name
//        }
//        
//        // Then
//        if let first = appState?.tunings.first {
//            XCTAssertEqual(chorGroupNamesArray?.contains(first.name ?? "xxx"), true)
//            XCTAssertEqual(chorGroupNamesArray?.count,  appState?.tunings.count)
//        }
//    }
//    
//    func test_iJamAudioManager_noteNamesArray_shouldHaveFortyThreeElements() {
//        let audioManager = iJamAudioManager()
//        
//        // Then
//        XCTAssertEqual(audioManager.noteNamesArray.count, 43)
//    }
//        
//    func test_iJamAudioManager_formerZone_shouldInitializeToNegativeOne () {
//        // When
//        let stringsView = StringsView(height: 400)
//        let zone = stringsView.formerZone
//
//        // Then
//        XCTAssertEqual(zone, -1)
//    }
//    
//    func test_iJamAudioManager_audioPlayerArray_ShouldHaveSixAudioPlayers() {
//        // Given
//        let audioManager = iJamAudioManager()
//        XCTAssertNotNil(audioManager.audioPlayerArray)
//        XCTAssertEqual(audioManager.audioPlayerArray.count, 6)
//        
//        // Then
//        var thisAudioPlayer: AVAudioPlayer?
//        
//        for _ in 0...30 {
//            thisAudioPlayer = audioManager.audioPlayerArray[Int.random(in: 0..<6)]
//            XCTAssertEqual(true, thisAudioPlayer?.isKind(of: AVAudioPlayer.self))
//        }
//    }
//    
//    func test_iJamAudioManager_thisZone_shouldInitializeToNegativeOne () {
//        // When
//        let stringsView = StringsView(height: 400)
//        let zone = stringsView.formerZone
//
//        // Then
//        XCTAssertEqual(zone, -1)
//    }
//}
