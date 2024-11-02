//
//  VolumeView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/29/22.
//

import SwiftData
import SwiftUI
import OSLog

struct VolumeView: View {
    @Query var appStates: [AppState]
    let imageWidth = 40.0
    
    func VolumeSlider() -> some View {
        Slider(
            value: Bindable(appStates.first!).volumeLevel,
            in: 0...10
        )
    }
    
    func SpeakerImage(isMuted: Bool) -> some View {
        Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2")
            .resizable()
            .frame(width: imageWidth, height: imageWidth)
            .shadow(radius: 10)
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding(10)
    }
    
    var body: some View {
        if let appState = appStates.first {
            HStack {
                Spacer()
                Button(action: {
                    appState.isMuted.toggle()
                }) {
                    SpeakerImage(isMuted: appState.isMuted)
                }
                VolumeSlider()
                Spacer()
            }
        }
    }
}

