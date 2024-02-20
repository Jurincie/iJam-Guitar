//
//  CreateChordGroupView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 1/1/24.
//

import OSLog
import SwiftData
import SwiftUI

struct CreateChordGroupView: View {
    @Environment(\.dismiss) var dismiss
    @Query var appStates: [AppState]
    @State private var chordGroupNameExistsAlert = false
    @State private var selectedChords: [Chord?] = Array(repeating: nil, 
                                                        count: 10)
    @State private var chordGroupName: String = ""
    @State private var currentTuning: Tuning?
    @State private var selectedChordIndex = 0
    var chordNames = [String]()
    var activeChordName: String = ""
    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    let mySpacing = UIDevice.current.userInterfaceIdiom == .pad ? 18.0 : 12.0
    @State private var activeButtonIndex = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(0.6)

            VStack {
                Spacer()
                Text("Enter GroupName")
                    .font(.title)
                TextField("Enter Group Name", text: $chordGroupName)
                    .cornerRadius(10)
                    .autocorrectionDisabled()
                    .border(.black, width: 1)
                    .padding()
                    .padding(.horizontal)
                VStack {
                    Text("Select Tuning:")
                        .font(.headline)
                    VStack {
                        Menu {
                            Picker("Tunings", selection: $currentTuning) {
                                ForEach(appStates.first!.getTuningNames(), id: \.self) {
                                    Text($0)
                                        .fixedSize()
                                }
                            }
                            .pickerStyle(.automatic)
                            .frame(maxWidth: .infinity)
                        } label: {
                            Text("TESTING")
                                .padding(10)
                                .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
                                .fontWeight(.semibold)
                                .background(Color.accentColor)
                                .foregroundColor(Color.white)
                                .cornerRadius(10.0)
                                .shadow(color: .white , radius: 2.0)
                                .fixedSize()
                        }
                    }
                 }
                .padding()
                .border(.black, width: 1)
                .cornerRadius(10)
                Spacer()
                Text("Tap on picks to select chords below")
                    .font(.headline)
                LazyVGrid(columns: columns,
                          spacing: mySpacing) {
                    ForEach(getUndefinedPicks(), id: \.id) { pick in
                        PickView2(selectedChordIndex: $selectedChordIndex, pick: pick)
                    }
                }
                Spacer()
                HStack {
                    Button(action: {
                        dismiss()
                    }, label: { Text("CANCEL")})
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                    
                    Button(action: {
                        Logger.viewCycle.debug("Create New ChordGroup Here")
                    }, label: { Text("SUBMIT")})
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                }
                Spacer()
            }
        }
        .ignoresSafeArea()
        .dynamicTypeSize(...DynamicTypeSize.large)
    }
        

    func getUndefinedPicks() -> [Pick] {
        var pickArray = [Pick]()
        for index in 0..<10 {
            pickArray.append(Pick(id: index, 
                                  chord: Chord(name: "", fretMapString: ""),
                                  image: Image(index == selectedChordIndex ? .activePick : .blankPick)))
        }
        
        return pickArray
    }
}

#Preview {
    return CreateChordGroupView()
}

