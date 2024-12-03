//
//  CreateChordHelpers.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 11/10/24.
//

import Foundation
import SwiftData
import SwiftUI

struct PickerView: View {
    @Query var appStates: [AppState]
    var tuningSelected: Bool
    @Binding var selectedTuningName: String
    @Binding var selectedChords: [Chord]
    @State private var animationAmount = 1.0
    
    var body: some View {
        if let appState = appStates.first {
            Menu {
                Picker("Tunings", selection: $selectedTuningName) {
                    ForEach(appState.tuningNames, id: \.self) {
                        Text($0)
                            .font(.caption)
                    }
                }
                .onChange(of: selectedTuningName, { selectedChords.removeAll() })
                .pickerStyle(.inline)
                .frame(maxWidth: .infinity)
            } label: {
                Text(selectedTuningName)
                    .padding()
                    .border(Color.white, width: 1)
                    .foregroundColor(.white)
                    .font(.headline)
                    .background(Color.accentColor)
                    .animation(.easeInOut, value: animationAmount)
            }
            .cornerRadius(2)
            Text(tuningSelected == false ? "" : "Choose up to 10 chords (below)")
                .font(.headline)
                .foregroundColor(.primary)
        }
    }
}

struct TextFieldView: View {
    @Binding var newChordGroupName: String
    
    var body: some View {
        Text("Create Chord Group")
            .foregroundStyle(Color.white)
            .font(.title)
        TextField("Enter Group Name", text: $newChordGroupName)
            .textFieldStyle(CustomTextFieldStyle())
    }
}

struct CustomTextFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.title)
            .padding(5)
        //Give it some style
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .border(.black, width: 2)
            .padding(.horizontal)
            .font(.headline)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color.primary.opacity(0.5), lineWidth: 1)
            )
    }
}

struct GridView: View {
    @Binding var selectedChords: [Chord]
    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    
    var body: some View {
        LazyVGrid(columns: columns,
                  spacing: 8) {
            let picks = getUndefinedPicks()
            ForEach(picks, id: \.id) { pick in
                CreateChordGroupPickView(selectedChords: $selectedChords, pick: pick)
            }
        }
        .padding()
        .border(.primary, width: 4)
        .cornerRadius(12)
        Divider()
    }
    
    func getUndefinedPicks() -> [Pick] {
        var pickArray = [Pick]()
        for index in 0...9 {
            pickArray.append(Pick(id: index,
                                  chord: Chord(name: "", fretMapString: ""),
                                  image: Image(.blankPick)))
        }
        
        return pickArray
    }
}
