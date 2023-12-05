//
//  FretNumbersView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/4/22.
//

import SwiftUI
import OSLog

struct FretNumbersView: View {
    @Binding var model: iJamModel
    let width: CGFloat
    let height: CGFloat
     
    var body: some View {
        
        VStack(alignment: .leading, spacing:0) {
            // lowest row is for the nut / open string / capo position
            CapoPositionPickerView(model: model)
                .frame(width: width, height: height / 6, alignment: .center)
                .background(Color.accentColor)
                .overlay(RoundedRectangle(cornerRadius:8)
                .stroke(.white, lineWidth: 2))
            // next 5 rows span the chord - from minfret to minFret + 5)
            ForEach((0...4), id: \.self) {
                Text(String(model.capoPosition + model.minimumFret + Int($0)))
                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
                    .fontWeight(.semibold)
                    .frame(width: width, height: height / 6, alignment: .center)
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .border(Color.white)
            }
        }
    }
}
