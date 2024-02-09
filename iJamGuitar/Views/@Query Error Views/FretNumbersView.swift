//
//  FretNumbersView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/4/22.
//

import SwiftData
import SwiftUI
import OSLog

struct FretNumbersView: View {
    @Query var appState: AppState
    let width: CGFloat
    let height: CGFloat
     
    var body: some View {
        VStack(alignment: .leading) {
            // lowest row is for the nut / open string / capo position
            CapoPositionPickerView(capoPosition: appState.capoPosition)
                .frame(width: width, height: height / 6)
                .background(Color.accentColor)
                .overlay(RoundedRectangle(cornerRadius:8)
                .stroke(.white, lineWidth: 2))
            // next 5 rows span the chord - from minfret to minFret + 5)
            ForEach((0...4), id: \.self) {
                Text(String(appState.capoPosition + appState.minimumFret + Int($0)))
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
