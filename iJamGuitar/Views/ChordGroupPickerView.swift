//
//  ChordGroupPickerView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/17/22.
//

import SwiftUI
import OSLog

@available(iOS 16.0, *)
struct ChordGroupPickerView: View {
    @Binding var model: iJamModel
    
    var body: some View {
        VStack {
            Menu {
                Picker("Chord Groups", selection: $model.activeChordGroupName) {
                    ForEach(model.getActiveTuningChordGroupNames(), id: \.self) {
                        Text($0)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
            } label: {
                Text(model.activeChordGroupName)
                    .padding(10)
                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
                    .fontWeight(.semibold)
                    .background(Color.accentColor)
                    .foregroundColor(Color.white)
                    .cornerRadius(10.0)
                    .shadow(color: .white , radius: 2.0)
            }
        }
    }
}

