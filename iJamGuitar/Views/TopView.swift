//
//  TopView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/25/22.
//

import SwiftUI
import OSLog

struct TopView: View {
    @Binding var model: iJamModel
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ChordButtonsView(model: $model, 
                         width: width,
                         height: height)
            .frame(width: width, 
                   height: height,
                   alignment: .center)
            .background( Image("TopView")
                .resizable()
                .frame(width: width, 
                       height: height,
                       alignment: .topLeading))
    }
}
