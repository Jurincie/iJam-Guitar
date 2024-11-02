//
//  FretNumbersView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/4/22.
//

import OSLog
import SwiftData
import SwiftUI

struct FretNumbersView: View {
    @Query var appStates: [AppState]
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        if let appState = appStates.first {
            VStack(alignment: .leading, spacing: 0) {
                Text(String(appState.capoPosition))
                    .frame(width: width, height: height / 6, alignment: .center)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .border(Color.white, width: 2)
                    .onTapGesture {
                        print("Tapped Capo Label")
                    }

                // next 5 rows span the chord - from minfret to minFret + 5)
                ForEach((0...4), id: \.self) {
                    Text(
                        String(
                            appStates.first!.capoPosition
                                + appStates.first!.minimumFret + Int($0))
                    )
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(width: width, height: height / 6, alignment: .center)
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .border(Color.white)
                }
            }
            .minimumScaleFactor(0.5)
        }
    }
}
