//
//  ChordGroupPickerView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 2/8/24.
//

import SwiftData
import SwiftUI
import OSLog

struct ChordGroupPickerView: View {
    @Environment(\.modelContext) var modelContext
    @Query var appStates: [AppState]
    
    var body: some View {
        let appState = appStates.first!
         VStack {
             Menu {
                 Picker("Chord Groups", selection: Bindable(appState).pickerChordGroupName) {
                     let chordGroupNames = appStates.first!.getActiveTuningChordGroupNames()
                     ForEach(chordGroupNames, id: \.self) {
                         Text($0)
                     }
                 }
                 .pickerStyle(.automatic)
                 .frame(maxWidth: .infinity)
                 .onChange(of: appState.pickerChordGroupName) { oldValue, newValue in
                     debugPrint("new ChordGroupName: \(newValue)")
                     appState.activeTuning?.activeChordGroup = appState.getChordGroup(name: newValue)
                 }
             } label: {
                 Text(appState.pickerChordGroupName)
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

