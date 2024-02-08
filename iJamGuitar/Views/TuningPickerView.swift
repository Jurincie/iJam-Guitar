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
    @Binding var activeTuningName: String
    var body: some View {
        VStack {
            Menu {
                Picker("Tunings", selection: $activeTuningName) {
                    ForEach(iJamViewModel.shared.getTuningNames(), id: \.self) {
                        Text($0)
                            .fixedSize()
                    }
                }
                .pickerStyle(.automatic)
                .frame(maxWidth: .infinity)
           } label: {
               Text("\(iJamViewModel.shared.activeTuningName)")
                   .padding(10)
                   .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
                   .fontWeight(.semibold)
                   .background(Color.accentColor)
                   .foregroundColor(Color.white)
                   .cornerRadius(10.0)
                   .shadow(color: .white , radius: 2.0)
                   .fixedSize()
           }
       }
        .frame(alignment: .trailing)
        .border(.white,
                width: 2,
                cornerRadius: 7)
    }
}

extension View {
    func border(_ color: Color, 
                width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width))
    }
}

