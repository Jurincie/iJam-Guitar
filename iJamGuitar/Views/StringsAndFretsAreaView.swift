//
//  StringsAndFretsAreaView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/5/22.
//

import SwiftData
import SwiftUI
import OSLog

// This view covers the area with the FretBoard and the Strings
//  The 6 centered string images go from top to bottom
//  The FretNumber images are to left and right of strings in TOP (frets) part
//  There are empty images to left and right of strings in BOTTOM part

struct StringsAndFretsAreaView : View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack() {
            // BOTTOM layer
            VStack(spacing:0) {
                // display frets in Top half
                HStack(spacing:0) {
                    FretNumbersView(width: width * 0.12,
                                    height: height / 2, 
                                    capoPosition: 0)
                    FretBoardView(width: width * 0.76,
                                  height: height / 2)
                    FretNumbersView(width: width * 0.12,
                                    height: height / 2,
                                    capoPosition: 0)
                }
                // display StringAreaView in Lower half
                Image("StringAreaView")
                    .resizable()
                    .frame(width: width, 
                           height: height / 2,
                           alignment: .top)
            }
            
            // TOP layer
            StringsView(height: height)
        }
    }
}
