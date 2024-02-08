//
//  TopView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/25/22.
//

import SwiftUI
import OSLog

struct TopView: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ChordButtonsView(width: width,
                         height: height)
            .frame(width: width, 
                   height: height)
            // background image (could have used z-stack here instead
            .background( Image("TopView")
                .resizable()
                .frame(width: width, 
                       height: height,
                       alignment: .topLeading))
    }
}
