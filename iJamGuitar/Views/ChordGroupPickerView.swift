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
    @Binding var model: iJamViewModel
    
    var body: some View {
        VStack {
            Menu {
                Picker("Chord Groups", selection: $model.activeChordGroupName) {
                    let chordGroupNames = model.getActiveTuningChordGroupNames()
                    ForEach(chordGroupNames, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.automatic)
                .frame(maxWidth: .infinity)
            } label: {
                Text(model.activeChordGroupName)
                    .padding(10)
                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
                    .fontWeight(.semibold)
                    .background(Color.accentColor)
                    .foregroundColor(Color.white)
                    .shadow(color: .white , radius: 2.0)
            }
        }
    }
}

