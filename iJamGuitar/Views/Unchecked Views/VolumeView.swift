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
    @State private var volumeAmount: Double = 0.0
    @State var isMuted: Bool
    let imageWidth = UIDevice.current.userInterfaceIdiom == .pad ? 35.0 : 25.0
    
    init(
        volumeAmount: Double,
        isMuted: Bool) {
        self.volumeAmount = volumeAmount
        self.isMuted = isMuted
    }
   
    func VolumeSlider() -> some View {
        Slider(
            value: $volumeAmount,
            in: 0...10
        )
    }
    
    func SpeakerImage(isMuted: Bool) -> some View {
        Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.1")
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
                    isMuted.toggle()
                }) {
                    SpeakerImage(isMuted: isMuted)
                }
                VolumeSlider()
                Spacer()
            }
            Spacer()
        }
    }
}

