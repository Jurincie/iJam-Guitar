//
//  BottomView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/25/22.
//

import SwiftUI
import OSLog

struct BottomView: View {
    @Binding var model: iJamViewModel
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack() {
            Image("BottomView")
                .resizable()
                .frame(width:width, 
                       height:height,
                       alignment:.topLeading)
            VStack() {
                VolumeView(model: $model)
                    .padding(.horizontal, 40)
            }
        }
    }
}
