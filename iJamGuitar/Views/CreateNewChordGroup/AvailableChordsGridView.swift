//
//  AvailableChordsGridView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 2/20/24.
//

import OSLog
import SwiftData
import SwiftUI

struct AvailableChordsGridView: View {
    @Query var appStates: [AppState]
    @Binding var selectedChords: [Chord]
    
    var body: some View {
        let appState = appStates.first!
        let chordDictionary: [String:String] = appState.activeTuning!.chordsDictionary
        let columns = Array(repeating: GridItem(.flexible()), count: 4)
        let keys = chordDictionary.map{$0.key}
        let values = chordDictionary.map {$0.value}
        
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(0..<keys.count, id: \.self) { index in
                    AvailablePickView(selectedChords: $selectedChords, name: keys[index], fretMapString: values[index])
                }
            }
        }
        .contentMargins(.trailing, 20, for: .scrollContent)
        .scrollIndicatorsFlash(onAppear: true)
        .padding()
        .border(.black, width: 4)
        .cornerRadius(12)
    }
}

struct AvailablePickView: View {
    @State private var isActive: Bool = false
    @Binding var selectedChords: [Chord]
    let name: String
    let fretMapString: String
    
    var body: some View {
        Button {
            if (isActive == false && selectedChords.count >= 10) {
            } else {
                isActive.toggle()
                
                if isActive {
                    let chord = Chord(name: name,
                                      fretMapString: fretMapString)
                    selectedChords.append(chord)
                    Logger.viewCycle.debug("Added Chord: \(chord.name)")
                } else {
                    if let index = selectedChords.firstIndex(where: { chord in
                        chord.name == name
                    }) {
                        let name = selectedChords[index].name
                        selectedChords.remove(at: index)
                        Logger.viewCycle.debug("Removed Chord: \(name)")
                    }
                }
            }
            
        } label: {
            ZStack {
                Image(isActive ? .activePick : .blankPick)
                    .resizable()
                    .scaledToFill()
                
                // Foreground
                VStack(spacing: 5) {
                    Spacer()
                    Text(name)
                        .bold()
                    Text(fretMapString)
                    Spacer()
                }
                .font(.caption)
                .foregroundColor(.white)
            }
        }
    }
}

//#Preview {
//    AvailableChordsGridView(selectedChords: [])
//}
