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
    @Query var appStates: [AppState]

    var body: some View {
        ZStack() {
            Image(.bottomView)
                .resizable()
                .frame(width:width,
                       height:height,
                       alignment:.topLeading)
            VStack() {
                if let appState = appStates.first {
                    VolumeView(isMuted: appState.isMuted)
                        .padding(.horizontal, 40)
                }
            }
        }
    }
}
