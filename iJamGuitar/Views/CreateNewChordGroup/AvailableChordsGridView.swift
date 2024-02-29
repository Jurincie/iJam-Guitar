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
   
    var multiLineNotice = """
    Select a Tuning (Above)
    to load available chords
    """
    
    var body: some View {
        if tuningSelected == false {
            VStack {
                Spacer()
                Text(multiLineNotice)
                Spacer()
            }
            .foregroundColor(.black)
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
                
                // sort tuple array
                let keyValues = zip(keys, values).sorted { tuple1, tuple2 in
                    tuple1.0 < tuple2.0
                }
                let columns = Array(repeating: GridItem(.flexible()), count: 4)
                
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(0..<keyValues.count, id: \.self) { index in
                            AvailablePickView(selectedChords: $selectedChords,
//                                              selectedTuningName: $selectedTuningName,
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
}

struct AvailablePickView: View {
    @Binding var selectedChords: [Chord]
    
    // Stored Properties
    let name: String
    let fretMapString: String
    
    // Computed Properties
    var isActive: Bool {
        if let found = selectedChords.firstIndex(where: { chord in
            chord.name == name
        }) {
            return true
        }
        return false
    }
    var canAddPicks: Bool {
        selectedChords.count < 10
    }
    
    var body: some View {
        Button {
            if (isActive == false && canAddPicks == false) {
                // ignore tap
            } else {
                if isActive == false {
                    // user tapped on inactive pick
                    // append chord from this name and fretMapString
                    let chord = Chord(name: name,
                                      fretMapString: fretMapString)
                    selectedChords.append(chord)
                    Logger.viewCycle.debug("Added Chord: \(chord.name)")
                } else {
                    // User tapped on an active pick
                    if let index = selectedChords.firstIndex(where: { chord in
                        chord.name == name
                    }) {
                        // remove this pick chord
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
                        .font(.caption)
                        .bold()
                    Text(fretMapString)
                        .font(.caption)
                    Spacer()
                }
                .font(.caption)
                .foregroundColor(.white)
            }
        }
    }
}
