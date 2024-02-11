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
    @State private var dragLocation: CGPoint?
    let audioManager: iJamAudioManager
    var height: CGFloat
    var appState: AppState
    var drag: some Gesture {
        DragGesture()
            .onEnded { _ in
                audioManager.formerZone = -1
            }
            .onChanged { drag in
                dragLocation = drag.location
                audioManager.newDragLocation(dragLocation)
                Logger.viewCycle.debug("Drag[x] = \(drag.location.x)")
            }
    }
    
    init(height: CGFloat,
         showVolumeAlert: Bool,
         appState: AppState) {
        self.height = height
        self.audioManager = iJamAudioManager()
        self.appState = appState
    }
    
    var body: some View {
        HStack() {
            SixSpacerHStack()
            HStack(spacing:0) {
                ForEach(0...5, id: \.self) { index in
                    StringView(height: height,
                               stringNumber: 6 - index)
                    .readFrame { newFrame in
                        audioManager.zoneBreaks[index] = (newFrame.maxX + newFrame.minX) / 2.0
                    }
                }
                SixSpacerHStack()
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
    }
    
    struct SixSpacerHStack: View {
        var body: some View {
            HStack() {
                ForEach(0...5, id: \.self) { _ in
                    Spacer()
                }
            }
        }
    }
    
    func playOpeningArpegio() async {
        Logger.viewCycle.debug("ZoneBreaks: \(audioManager.zoneBreaks)")
        for string in 0...5 {
            audioManager.pickString(6 - string)
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
        
        Logger.viewCycle.debug("zoneBreaks: \(audioManager.zoneBreaks)")
    }
}



