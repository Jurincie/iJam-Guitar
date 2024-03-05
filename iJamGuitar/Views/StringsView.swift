//
//  StringView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/3/22.
//

import SwiftData
import SwiftUI
import OSLog

///  StringsView
///  is responsible for displaying the 6 StringView views
///  and obtaining the bounds of each of the strings via their Anchor Preferences
///
/// StringsView moitors a DragGesture's position to track when to pluck a string to play its  Audio player
///
/// Zone 0:  left of string 6
/// Zone 1:  inside String 6
/// Zone 2:  between Strings 6 - 5
/// Zone 3:  inside String 5
/// Zone 4:  between Strings 5 - 4
/// Zone 5:  inside String 4
/// Zone 6:  between Strings 4 - 3
/// Zone 7:  inside String 3
/// Zone 8:  between Strings 3 - 2
/// Zone 9:  inside String 2
/// Zone 10: between Strings 2 - 1
/// Zone 11: inside String 1
/// Zone 12: right of String 1

struct StringsView: View {
    @Query var appStates: [AppState]
    @State private var dragLocation: CGPoint?
    @State var formerZone = -1
    @State private var zoneBreaks:[Double] = Array(repeating: 0.0, count: 6)
    
    // Stored Properties
    let audioManager = iJamAudioManager()
    var height: CGFloat
    let kNoFret = -1
    
    // Computed Property
    var drag: some Gesture {
        DragGesture()
            .onEnded { _ in formerZone = -1 }
            .onChanged { drag in
                dragLocation = drag.location
                newDragLocation(dragLocation)
            }
    }
    
    init(height: CGFloat) {
        self.height = height
    }
    
    var body: some View {
        let appState = appStates.first!
        HStack() {
            SixHorizontalSpacers()
            ForEach(0..<6) { index in
                StringView(height: height,
                           stringNumber: 6 - index)
                .readFrame { newFrame in
                    zoneBreaks[index] = (newFrame.maxX + newFrame.minX) / 2.0
                }
            }
            SixHorizontalSpacers()
        }
        .task({ await playOpeningArpegio() })
        .contentShape(Rectangle())
        .gesture(drag)
        .alert("Master Volume is OFF",
               isPresented: Bindable(appState).showVolumeAlert) {
            Button("OK", role: .cancel) { appState.showVolumeAlert = false }
        }
               .alert("Another App is using the Audio Player",
                      isPresented: Bindable(appState).showAudioPlayerInUseAlert) {
                   Button("OK", role: .cancel) { appState.showAudioPlayerInUseAlert = false }
               }
                      .alert("Unknown Audio Player Error", isPresented: Bindable(appState).showAudioPlayerErrorAlert) {
                          Button("OK", role: .cancel) { fatalError() }
                      }
        
    }
    
    struct SixHorizontalSpacers: View {
        var body: some View {
            HStack() {
                ForEach(0...5, id: \.self) { _ in
                    Spacer()
                }
            }
        }
    }
}

extension StringsView {
    // Drag Management
    func getZone(loc: CGPoint) -> Int{
        // ZoneBreaks[n] is left-most position of string[n + 1]
        var zone = 0
        
        if loc.x < zoneBreaks[0] {
            zone = 6    // left of string 6
        } else if loc.x < zoneBreaks[1] {
            zone = 5    // between string 6 and string 5
        } else if loc.x < zoneBreaks[2] {
            zone = 4  // between string 5 and string 4
        } else if loc.x < zoneBreaks[3] {
            zone = 3  // between string 4 and string 3
        } else if loc.x < zoneBreaks[4] {
            zone = 2  // between string 3 and string 2
        } else if loc.x < zoneBreaks[5] {
            zone = 1  // between string 2 and string 1
        } else {
            zone = 0  // right of string 1
        }
        
        return zone
    }
    
    func stringNumberToPlay(zone: Int, oldZone: Int) -> Int {
        return oldZone > zone ? oldZone : zone
    }
    
    ///   Description: This method determines if we are in a new zone -
    ///   and if we should then play note on appropriate string
    /// - Parameter location:- the current location of the drag in global co-ordinates
    func newDragLocation(_ location: CGPoint?) {
        guard let location =  location else { return }
        Logger.viewCycle.debug("Drag[x] = \(location.x)")
        let zone = getZone(loc: location)
        if zone != formerZone {
            Logger.viewCycle.notice("====> In New Zone: \(zone)")
            
            if formerZone >= 0 && appStates.first!.isMuted == false {
                let stringToPlay: Int = stringNumberToPlay(zone: zone, oldZone: formerZone)
                pickString(stringToPlay)
            }
            formerZone = zone
        }
    }
    
    /// Description: This method identifies the note to play on this string based on capo position and fret -
    ///  and then plays that string if the string is not muted
    /// - Parameter stringToPlay: The String to be played
    func pickString(_ stringToPlay: Int) {
        guard audioManager.isVolumeLevelZero == false else {
            appStates.first!.showVolumeAlert.toggle()
            return
        }
        
        let openNotes = appStates.first!.activeTuning?.openNoteIndices.components(separatedBy: "-")
        let fretPosition = appStates.first!.currentFretPositions[6 - stringToPlay]
        if fretPosition > kNoFret {
            if let noteIndices = openNotes, let thisStringsOpenIndex = Int(noteIndices[6 - stringToPlay]) {
                let index = fretPosition + thisStringsOpenIndex + appStates.first!.capoPosition
                let noteToPlayName = audioManager.noteNamesArray[index]
                let volume = appStates.first!.volumeLevel
                Logger.viewCycle.debug("playing string: \(stringToPlay)")
                do {
                    try audioManager.playWaveFile(noteName:noteToPlayName,
                                                  stringNumber: stringToPlay,
                                                  volume: volume / 5.0)
                } catch {
                    Logger.viewCycle.error("Could not play wave file...")
                }
            }
        }
    }
    
    func playOpeningArpegio() async {
        for string in 0...5 {
            pickString(6 - string)
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
        Logger.viewCycle.debug("-----> zoneBreaks: \(zoneBreaks)")
    }
}


