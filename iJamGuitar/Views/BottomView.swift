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
                VolumeView()
                    .padding(.horizontal, 40)
            }
        }
    }
}
