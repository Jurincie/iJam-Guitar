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
                Text("ActiveChordGroup:")
                Spacer()
                Text(appState.activeChordGroup?.name ?? "ERROR")
            }
            
            availableChordsView()
            
            Button("Change Chord Group") {
                let activeChordGroup = appState.activeTuning?.activeChordGroup
                var newChordGroup = activeChordGroup
                while newChordGroup == activeChordGroup {
                    newChordGroup = appState.activeTuning?.chordGroups.randomElement()
                }
                
                appState.activeTuning?.activeChordGroup = newChordGroup
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            
            activeChordView()
            fretMapView()
        }
        .padding()
    }
}

struct fretMapView: View {
    @Query var appStates: [AppState]
    var body: some View {
        HStack {
            Text("FretMap:")
            Spacer()
            Text(appStates.first!.activeChordGroup?.activeChord?.fretMapString ?? "Error-22")
        }
    }
}

struct activeChordView: View {
    @Query var appStates: [AppState]
    
    var body: some View {
        let appState = appStates.first!
        let activeChordName: String = appState.activeChordGroup?.activeChord?.name ?? "Error"
        HStack {
            Text("ActiveChord:")
            Spacer()
            Text(activeChordName)
        }
    }
}

struct availableChordsView: View {
    @Query var appStates: [AppState]
    
    var body: some View {
        let appState = appStates.first!
        HStack {
            Text("Chords are available:")
            Spacer()
            if appState.activeChordGroup?.availableChords != nil {
                Text("YES")
            } else {
                Text("No")
            }
        }
    }
}

#Preview {
    TestSwiftDataView()
}
