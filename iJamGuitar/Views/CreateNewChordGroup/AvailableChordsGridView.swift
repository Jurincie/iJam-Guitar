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
    @Binding var tuning: Tuning?
    @Binding var selectedChords: [Chord]
    var tuningSelected: Bool
    
    var body: some View {
        if tuningSelected == false {
            VStack {
                Spacer()
                Text("Select a Tuning (Above)")
                    .font(.title)
                Text("To load available chords")
                    .font(.title)
                Spacer()
            }
            .padding()
            .border(.black, width: 4)
        }
        else {
            let appState = appStates.first!
            let chordDictionary: [String:String] = appState.activeTuning!.chordsDictionary
            let columns = Array(repeating: GridItem(.flexible()), count: 4)
            let keys = chordDictionary.map{$0.key}
            let values = chordDictionary.map {$0.value}
            
            // sort tuple array
            let keyValues = zip(keys, values).sorted { tuple1, tuple2 in
                tuple1.0 < tuple2.0
            }
            
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<keyValues.count, id: \.self) { index in
                        AvailablePickView(selectedChords: $selectedChords,
                                          name: tuningSelected ? keyValues[index].0 : "",
                                          fretMapString: tuningSelected ? keyValues[index].1 : "")
                    }
                    .scrollTargetLayout()
                }
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicatorsFlash(onAppear: true)
            .scrollBounceBehavior(.always)
            .contentMargins(.trailing, 20, for: .scrollContent)
            .scrollIndicatorsFlash(onAppear: true)
            .padding()
            .border(.black, width: 4)
            .cornerRadius(12)
        }
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
                        .font(.title)
                        .bold()
                    Text(fretMapString)
                        .font(.headline)
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
