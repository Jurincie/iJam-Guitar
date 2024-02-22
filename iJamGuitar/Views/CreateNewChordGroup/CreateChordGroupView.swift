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
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Query var appStates: [AppState]
    
    // State Properties
    @State private var showNameFieldEmptyAlert = false
    @State private var showNoChordsSelectedAlert = false
    @State private var showChordGroupNameExistsAlert = false
    @State private var showNameTuningUndefinedAlert = false
    @State private var selectedChords = [Chord]()
    @State private var newChordGroupName: String = ""
    @State var selectedTuningName: String = "Select a Tuning"
    
    // Stored Properties
    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    let mySpacing = UIDevice.current.userInterfaceIdiom == .pad ? 10.0 : 5.0
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Enter Group Name", text: $newChordGroupName)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .border(.black, width: 1)
                .padding()
                .padding(.horizontal)
            VStack {
                Menu {
                    Picker("Tunings", selection: $selectedTuningName) {
                        ForEach(appStates.first!.getTuningNames(), id: \.self) {
                            Text($0)
                                .fixedSize()
                        }
                    }
                    .pickerStyle(.automatic)
                    .frame(maxWidth: .infinity)
                } label: {
                    if selectedTuningName == "Select a Tuning"{
                        Text(selectedTuningName)
                            .padding()
                            .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
                            .fontWeight(.semibold)
                            .background(Color.accentColor)
                            .foregroundColor(Color.white)
                            .shadow(color: .white , radius: 2.0)
                            .modifier(BlinkingModifier(duration:0.7))
                        
                    } else {
                        Text(selectedTuningName)
                            .padding()
                            .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
                            .fontWeight(.semibold)
                            .background(Color.accentColor)
                            .foregroundColor(Color.white)
                            .shadow(color: .white , radius: 2.0)
                    }
                }
                .cornerRadius(10)
                .padding()
                
                LazyVGrid(columns: columns,
                          spacing: 8) {
                    ForEach(getUndefinedPicks(), id: \.id) { pick in
                        PickView2(selectedChords: $selectedChords, pick: pick)
                    }
                }
                Text("Choose up to 10 of the chords below")
                    .font(.headline)
                
                AvailableChordsGridView(tuning: Bindable<AppState>(appStates.first!).activeTuning,
                                        selectedChords: $selectedChords,
                                        tuningSelected: selectedTuningName != "Select a Tuning")
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
                    guard selectedTuningName != "Select a Tuning" else {  showNameTuningUndefinedAlert.toggle()
                        return
                    }
                    
                    Logger.viewCycle.debug("Create New ChordGroup Here")
                    if newChordGroupName.count == 0 {
                        showNameFieldEmptyAlert.toggle()
                    } else if selectedChords.count == 0 {
                        showNoChordsSelectedAlert.toggle()
                    } else {
                        if let selectedTuning: Tuning = appStates.first!.tunings.first(where: { tuning in
                            tuning.name == selectedTuningName
                        }) {
                            if let _ = selectedTuning.chordsDictionary.keys.first(where: { $0.contains(newChordGroupName) }) {
                                showChordGroupNameExistsAlert.toggle()
                            } else {
                                addNewChordGroup(selectedTuning: selectedTuning)
                                dismiss()
                            }
                        }
                        
                    }
                }, label: { Text("SUBMIT")})
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .padding()
        .background(LinearGradient(colors: [.yellow, .white, .gray], startPoint: .bottomLeading, endPoint: .topTrailing)
        )
        .alert("Please Select a Tuning", isPresented: $showNameTuningUndefinedAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert("You need to Enter a name for New Chord Group", isPresented: $showNameFieldEmptyAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert("No Chords Selected", isPresented: $showNoChordsSelectedAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert("Slected Tuning already has a ChordGroup with this name", isPresented: $showChordGroupNameExistsAlert) {
            Button("OK", role: .cancel) { }
        }
        .ignoresSafeArea()
        .dynamicTypeSize(...DynamicTypeSize.large)
    }
}

extension CreateChordGroupView {
    func addNewChordGroup(selectedTuning: Tuning) {
        var chordNamesString = selectedChords.reduce(into: "", { $0 += $1.name + "-" })
        chordNamesString.removeLast()
        
        let newChordGroup = ChordGroup(name: newChordGroupName,
                                       availableChordNames: chordNamesString)
        let selectedChords = appStates.first!.getAvailableChords(dictionary: selectedTuning.chordsDictionary)
        newChordGroup.activeChord = selectedChords.first
        newChordGroup.availableChords = selectedChords
        
        appStates.first!.activeTuning?.chordGroups.append(newChordGroup)
        appStates.first!.activeTuning?.activeChordGroup = newChordGroup
        appStates.first!.pickerChordGroupName = newChordGroup.name
        
        if let fretMapString = newChordGroup.activeChord?.fretMapString {
            appStates.first!.currentFretIndexMap = appStates.first!.getFretIndexMap(fretMapString: fretMapString)
            Logger.viewCycle.debug("Just Created New ChordGroup: \(newChordGroupName)")
        }
    }
    
    func getUndefinedPicks() -> [Pick] {
        var pickArray = [Pick]()
        for index in 0...9 {
            pickArray.append(Pick(id: index,
                                  chord: Chord(name: "",
                                               fretMapString: ""),
                                  image: Image(.blankPick)))
        }
        
        return pickArray
    }
}


