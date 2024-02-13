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
    @Query var appStates: [AppState]
    
    var body: some View {
        let appState = appStates.first!
         VStack {
             Menu {
                 Picker("Chord Groups", selection: Bindable(appState).activeChordGroupName) {
                     let chordGroupNames = appState.getActiveTuningChordGroupNames()
                     ForEach(chordGroupNames, id: \.self) {
                         Text($0)
                     }
                 }
                 .pickerStyle(.automatic)
                 .frame(maxWidth: .infinity)
             } label: {
                 Text(appState.activeChordGroupName)
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

