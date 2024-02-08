//
//  ChordGroupPickerView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/17/22.
//

import SwiftData
import SwiftUI
import OSLog

struct ChordGroupPickerView: View {
    var viewModel = iJamViewModel.shared
    @Binding var activeChordGroupName: String
    
    var body: some View {
        VStack {
            Menu {
                Picker("Chord Groups", selection: $activeChordGroupName) {
                    let chordGroupNames = viewModel.getActiveTuningChordGroupNames()
                    ForEach(chordGroupNames, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.automatic)
                .frame(maxWidth: .infinity)
            } label: {
                Text(viewModel.activeChordGroupName)
                    .padding(10)
                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
                    .fontWeight(.semibold)
                    .background(Color.accentColor)
                    .foregroundColor(Color.white)
                    .shadow(color: .white , 
                            radius: 2.0)
            }
        }
        .frame(alignment: .trailing)
        .border(.white,
                width: 2,
                cornerRadius: 7)
    }
}

