//
//  StringView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/3/22.
//



import AVFoundation
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
///
struct StringsView: View {
    @Bindable var model: iJamModel
    @State private var dragLocation: CGPoint?
    let halfStringWidth = 10.0
    let audioManager: iJamAudioManager
    var height: CGFloat
    var drag: some Gesture {
        DragGesture()
            .onEnded { _ in audioManager.formerZone = -1 }
            .onChanged { drag in
            dragLocation = drag.location
                audioManager.newDragLocation(dragLocation)
                Logger.viewCycle.debug("Drag[x] = \(drag.location.x)")
        }
    }
    
    init(model: iJamModel, height: CGFloat) {
        self.model = model
        self.height = height
        self.audioManager = iJamAudioManager(model: model)
    }

    var body: some View {
        HStack() {
            SixSpacerHStack()
            HStack(spacing:0) {
                StringView(model: model, 
                           height: height,
                           stringNumber: 6)
                .readFrame { newFrame in
                    audioManager.zoneBreaks[0] = newFrame.minX
                }
                Spacer()
                StringView(model: model,
                           height: height,
                           stringNumber: 5)
                .readFrame { newFrame in
                    audioManager.zoneBreaks[1] = newFrame.minX
                }
                Spacer()
                StringView(model: model,
                           height: height,
                           stringNumber: 4)
                .readFrame { newFrame in
                    audioManager.zoneBreaks[2] = newFrame.minX
                }
                Spacer()
            }
            HStack() {
                StringView(model: model,
                           height: height,
                           stringNumber: 3)
                .readFrame { newFrame in
                    audioManager.zoneBreaks[3] = newFrame.minX
                }
                Spacer()
                StringView(model: model,
                           height: height,
                           stringNumber: 2)
                .readFrame { newFrame in
                    audioManager.zoneBreaks[4] = newFrame.minX
                }
                Spacer()
                StringView(model: model,
                           height: height, 
                           stringNumber: 1)
                .readFrame { newFrame in
                    audioManager.zoneBreaks[5] = newFrame.minX
                }
            }
            SixSpacerHStack()
        }
        .task({await playOpeningArpegio()})
        .contentShape(Rectangle())
        .gesture(drag)
        .alert("Master Volume is OFF", isPresented: $model.showVolumeAlert) {
            Button("OK", role: .cancel) { model.showVolumeAlert = false }
        }
        .alert("Another App is using the Audio Player", isPresented: $model.showAudioPlayerInUseAlert) {
            Button("OK", role: .cancel) { model.showAudioPlayerInUseAlert = false }
        }
        .alert("Unknown Audio Player Error", isPresented: $model.showAudioPlayerErrorAlert) {
            Button("OK", role: .cancel) { fatalError() }
        }
    }
    
    func playOpeningArpegio() async {
        for string in 0...5 {
            audioManager.pickString(6 - string)
            try? await Task.sleep(nanoseconds: 0_150_000_000)
        }
        
        Logger.viewCycle.debug("zoneBreaks: \(audioManager.zoneBreaks)")
    }

    struct SixSpacerHStack: View {
        var body: some View {
            HStack() {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
        }
    }
}


