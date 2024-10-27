//
//  TuningPickerView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 2/19/24.
//

import OSLog
import SwiftData
import SwiftUI

struct TuningPickerView: View {
    @Binding var tuningName: String
    @Binding var chordGroupName: String
    @Query var appStates: [AppState]
    
    var body: some View {
        VStack {
            Spacer()
            Menu {
                Picker("Tunings", selection: $tuningName) {
                    if let appState = appStates.first {
                        let tuningNames = appState.tuningNames
                        ForEach(tuningNames, id: \.self) {
                            Text($0)
                        }
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: tuningName, { oldValue, newValue in
                    Logger.viewCycle.notice("new Tuning name: \(newValue)")
                    
                    if let newTuning = appStates.first!.tunings.first(where: { tuning in
                        tuning.name == newValue
                    }) {
                        if let activeGroup = newTuning.activeChordGroup {
                            chordGroupName =  activeGroup.name
                        } else {
                            newTuning.activeChordGroup = newTuning.chordGroups.first
                            chordGroupName =  newTuning.activeChordGroup?.name ?? ""
                        }
                        appStates.first!.activeTuning = newTuning
                        appStates.first!.pickerTuningName = newTuning.name ?? "ERROR"
                        appStates.first!.pickerChordGroupName =  appStates.first!.activeChordGroup?.name ?? ""
                        appStates.first!.currentFretPositions = appStates.first!.activeChordFretMap
                    }
                })
            } label: {
                if let appState = appStates.first {
                    Text(appState.pickerTuningName)
                        .padding()
                        .font(.headline)
                        .fontWeight(.semibold)
                        .background(Color.accentColor)
                        .foregroundColor(Color.white)
                }
            }
            Spacer()
        }
        .frame(maxHeight: 42)
        .border(.white, width: 3)
        .cornerRadius(8)
    }
}
