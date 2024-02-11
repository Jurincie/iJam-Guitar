//
//  TuningPickerView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/18/22.
//

import SwiftData
import SwiftUI
import OSLog

struct TuningPickerView: View {
//    @Query var appState: AppState
    
    var body: some View {
        Text("")
//        VStack {
//            Menu {
//                Picker("Tunings", selection: Bindable(appState).activeTuningName) {
//                    ForEach(appState.getTuningNames(), id: \.self) {
//                        Text($0)
//                            .fixedSize()
//                    }
//                }
//                .pickerStyle(.automatic)
//                .frame(maxWidth: .infinity)
//           } label: {
//               Text("\(appState.activeTuningName)")
//                   .padding(10)
//                   .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
//                   .fontWeight(.semibold)
//                   .background(Color.accentColor)
//                   .foregroundColor(Color.white)
//                   .cornerRadius(10.0)
//                   .shadow(color: .white , radius: 2.0)
//                   .fixedSize()
//           }
//       }
//        .frame(alignment: .trailing)
//        .border(.white,
//                width: 2,
//                cornerRadius: 7)
    }
}

extension View {
    func border(_ color: Color, 
                width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width))
    }
}

