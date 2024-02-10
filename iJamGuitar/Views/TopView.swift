//
//  TopView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/25/22.
//

import SwiftUI
import OSLog

struct TopView: View {
    @Binding var model: iJamViewModel
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ChordButtonsView(model: $model, 
                         width: width,
                         height: height)
            .frame(width: width, 
                   height: height,
                   alignment: .center)
            // background image (could have used z-stack here instead
            .background( Image("TopView")
                .resizable()
                .frame(width: width, 
                       height: height,
                       alignment: .topLeading))
    }
}
