//
//  BottomView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/25/22.
//

import SwiftData
import SwiftUI
import OSLog

struct BottomView: View {
    let width: CGFloat
    let height: CGFloat
    @Query var appState: AppState
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }

    var body: some View {
        ZStack() {
            Image("BottomView")
                .resizable()
                .frame(width:width, 
                       height:height,
                       alignment:.topLeading)
            VStack() {
                VolumeView(volumeAmount: appState.volumeLevel,
                           isMuted: appState.isMuted)
                    .padding(.horizontal, 40)
            }
        }
    }
}
