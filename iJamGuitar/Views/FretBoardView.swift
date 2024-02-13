//
//  FretbBoardView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/25/22.
//

import SwiftUI
import OSLog

struct FretBoardView: View {
    let width:CGFloat
    let height:CGFloat
    
    var body: some View {
        // width coming in is 76% of parent (StringsAndFretsAreaView)
        // height is parents trueHeight / 2
        // since this covers bottom half of parent (StringsAndFretsAreaView)
        VStack() {
            Image(.nut)
                .resizable()
                .frame(width: width, 
                       height: height / 6,
                       alignment: .top)
            Spacer()
        }
        .background( Image(.fretBoard)
            .resizable()
            .frame(width: width, 
                   height: height,
                   alignment: .top))
    }
}
