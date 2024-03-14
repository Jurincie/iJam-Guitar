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
    @Binding var selectedTuningName: String
    @Binding var selectedChords: [Chord]
    var tuningSelected: Bool
    
    var body: some View {
        if tuningSelected == false {
            VStack {
                Text("Select Tuning Above")
                    .frame(alignment: .top)
                    .bold()
                    .font(.title)
            }
            .foregroundColor(.primary)
            .padding()
            .border(.black, width: 4)
        }
        else {
            let tuning = appStates.first!.tunings.first { tuning in
                tuning.name == selectedTuningName
            }
            
            if let chordDictionary: [String:String] = tuning?.chordsDictionary {
                let keys = chordDictionary.map{$0.key}
                let values = chordDictionary.map {$0.value}
                
                // create then sort tuple array
                let keyValues = zip(keys, values).sorted { tuple1, tuple2 in
                    tuple1.0 < tuple2.0
                }
                let columns = Array(repeating: GridItem(.flexible()), count: 4)
                
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
                .scrollBounceBehavior(.always)
                .contentMargins(.trailing, 20, for: .scrollContent)
                .scrollIndicatorsFlash(onAppear: true)
                .padding()
                .border(.black, width: 4)
                .cornerRadius(12)
            }
            
        }
    }
}

struct AvailablePickView: View {
    @Binding var selectedChords: [Chord]
    
    // Stored Properties
    let name: String
    let fretMapString: String
    @State private var isSelected = false
    
    var canAddPicks: Bool {
        selectedChords.count < 10
    }
    
    var body: some View {
        Button(action: {
            if isSelected == false {
                // user tapped on unselected pick
                if canAddPicks {
                    // append chord from this name and fretMapString
                    let chord = Chord(name: name, fretMapString: fretMapString)
                    selectedChords.append(chord)
                    isSelected = true
                    Logger.viewCycle.debug("Added Chord: \(chord.name)")
                }
            } else {
                // User tapped on an selected pick
                if let index = selectedChords.firstIndex(where: { chord in
                    chord.name == name
                }) {
                    // remove this pick chord
                    let name = selectedChords[index].name
                    selectedChords.remove(at: index)
                    isSelected = false
                    Logger.viewCycle.debug("Removed Chord: \(name)")
                }
            }
        }, label: {
            ZStack {
                // Backgroune
                Image(isSelected ? .activePick : .blankPick)
                    .resizable()
                    .scaledToFill()
                // Foreground
                VStack(spacing: 5) {
                    Spacer()
                    Text(name)
                        .font(.caption)
                        .bold()
                    Text(fretMapString)
                        .font(.caption)
                    Spacer()
                }
                .font(.caption)
                .foregroundColor(.primary)
            }
        })
    }
}
