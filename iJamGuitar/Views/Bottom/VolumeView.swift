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
    @State private var isEditing = false
 
    let imageWidth = UserDefaults.standard.bool(forKey: "IsIpad") ? 35.0 : 25.0
    var isMuted: Bool
    
    func VolumeSlider() -> some View {
        Slider(
            value: Bindable(appStates.first!).volumeLevel,
            in: 0...10
        )
    }
    
    func SpeakerImage() -> some View {
        
        Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.1")
            .resizable()
            .frame(width: imageWidth, height: imageWidth)
            .shadow(radius: 10)
            .foregroundColor(Color.white)
            .padding(10)
    }
    
    var body: some View {
        if let appState = appStates.first {
            VStack() {
                Spacer()
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        appState.isMuted.toggle()
                    }) {
                        SpeakerImage()
                    }
                    VolumeSlider()
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

