//
//  TestSwiftDataView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 2/15/24.
//

import SwiftData
import SwiftUI

struct TestSwiftDataView: View {
    @Query private var appStates: [AppState]
    
    var body: some View {
        let appState = appStates.first!
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Text("Capo Position: \(appState.capoPosition)")
                Spacer()
                Button {
                    appState.capoPosition -= 1
                } label: {
                    Image(systemName: "minus")
                }
                Button {
                    appState.capoPosition += 1
                } label: {
                    Image(systemName: "plus")
                }
            }
            
            HStack(spacing: 10) {
                Text("Volume: \(appState.volumeLevel)")
                Spacer()
                
                Button {
                    appState.volumeLevel -= 1
                } label: {
                    Image(systemName: "minus")
                }
                Button {
                    appState.volumeLevel += 1
                } label: {
                    Image(systemName: "plus")
                }
            }
            if let activeTuning = appState.activeTuning {
                Text("activeTuning: " + activeTuning.name!)
            }
            
            HStack(spacing: 10) {
                Text("ActiveChordGroup: " + (appState.activeChordGroup?.name ?? "ERROR"))
                Spacer()
            }
            
            Button("Randomize active chord Group") {
                appState.activeTuning?.activeChordGroup = appState.activeTuning?.chordGroups.randomElement()
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

#Preview {
    TestSwiftDataView()
}
