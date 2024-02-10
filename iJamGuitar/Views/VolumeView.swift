//
//  VolumeView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/29/22.
//

import SwiftUI
import OSLog

struct VolumeView: View {
    @Binding var model: iJamViewModel
    @State private var isEditing = false
    let imageWidth = UIDevice.current.userInterfaceIdiom == .pad ? 35.0 : 25.0
    
    func VolumeSlider() -> some View {
        Slider(
            value: $model.volumeLevel,
            in: 0...10
        )
    }
    
    func SpeakerImage() -> some View {
        Image(systemName: model.isMuted ? "speaker.slash.fill" : "speaker.wave.1")
            .resizable()
            .frame(width: imageWidth, height: imageWidth)
            .shadow(radius: 10)
            .foregroundColor(Color.white)
            .padding(10)
    }
    
    var body: some View {
        VStack() {
            Spacer()
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    model.isMuted.toggle()
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

