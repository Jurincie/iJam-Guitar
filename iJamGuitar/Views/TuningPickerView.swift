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
            Menu {
                Picker("Tunings", selection: $tuningName) {
                    let tuningNames = appStates.first!.getTuningNames()
                    ForEach(tuningNames, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.automatic)
                .onChange(of: tuningName, { oldValue, newValue in
                    Logger.viewCycle.notice("new Tuning name: \(newValue)")
                    if let newTuning = appStates.first!.getTuning(name: newValue) {
                        if let activeGroup = newTuning.activeChordGroup {
                            chordGroupName =  activeGroup.name
                            appStates.first!.makeNewTuningActive(newTuning: newTuning)
                        } else {
                            newTuning.activeChordGroup = newTuning.chordGroups.first
                            chordGroupName =  newTuning.activeChordGroup?.name ?? ""
                            appStates.first!.makeNewTuningActive(newTuning: newTuning)
                        }
                    }
                })
            } label: {
                Text(appStates.first!.pickerTuningName)
                    .padding()
                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
                    .fontWeight(.semibold)
                    .background(Color.accentColor)
                    .foregroundColor(Color.white)
            }
        }
        .frame(maxHeight: UIDevice.current.userInterfaceIdiom == .pad ? 48 : 36)
        .border(.white,
                width: 3)
        .cornerRadius(8)
    }
}

//#Preview {
//    TuningPickerView()
//}
