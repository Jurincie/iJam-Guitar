//
//  TopView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/25/22.
//

import SwiftData
import SwiftUI
import OSLog

struct TopView: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ChordButtonsView(width: width,
                         height: height)
            .frame(width: width, 
                   height: height,
                   alignment: .center)
        
            // background image (could have used z-stack here instead
            .background(
                Image(.topView)
                .resizable()
                .frame(width: width,
                       height: height,
                       alignment: .topLeading)
            )
    }
}
