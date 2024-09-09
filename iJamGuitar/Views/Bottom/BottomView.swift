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
    @Query var appStates: [AppState]
    
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        if let appState = appStates.first {
            ZStack() {
                Image(.bottomView)
                    .resizable()
                    .frame(width:width,
                           height:height,
                           alignment:.topLeading)
                VStack() {
                    VolumeView(isMuted: appState.isMuted)
                        .padding(.horizontal, 40)
                }
            }
        }
    }
}
