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

    var body: some View {
        ZStack() {
            Image(.bottomView)
                .resizable()
                .frame(width:width,
                       height:height,
                       alignment:.topLeading)
            VStack() {
                VolumeView()
                    .padding(.horizontal, 40)
            }
        }
    }
}
