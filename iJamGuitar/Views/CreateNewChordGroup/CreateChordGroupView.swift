//
//  CreateChordGroupView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 1/1/24.
//

import OSLog
import SwiftData
import SwiftUI
import Foundation

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
    
    // Calculated Property
    var tuningSelected: Bool {
        selectedTuningName != "Select a Tuning"
    }
    
    var body: some View {
        VStack(alignment: .center) {
            TextFieldView(newChordGroupName: $newChordGroupName)
            VStack {
                GridView(selectedChords: $selectedChords)
                PickerView(tuningSelected: tuningSelected, 
                           selectedTuningName: $selectedTuningName,
                           selectedChords: $selectedChords)
                .cornerRadius(5)
                AvailableChordsGridView(selectedTuningName: $selectedTuningName,
                                        selectedChords: $selectedChords,
                                        tuningSelected: selectedTuningName != "Select Tuning")
            }
            HStack {
                Button(action: {
                    dismiss()
                }, label: { Text("CANCEL")})
                .frame(alignment: .bottom)
                .buttonStyle(.borderedProminent)
                Spacer()
                Button(action: {
                    guard tuningSelected else {
                        showNameTuningUndefinedAlert.toggle()
                        return
                    }
                    setupTuning()
                }, label: { Text("SUBMIT")})
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .padding()
        .background(Image(.topView)
            .resizable()
            .scaledToFill()
            .opacity(0.2))
        .alert("Please Select a Tuning", isPresented: $showNameTuningUndefinedAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert("Enter a name for new ChordGroup", isPresented: $showNameFieldEmptyAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert("No Chords Selected", isPresented: $showNoChordsSelectedAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert("Selected Tuning already has a ChordGroup with this name", isPresented: $showChordGroupNameExistsAlert) {
            Button("OK", role: .cancel) { }
        }
        .ignoresSafeArea()
        .dynamicTypeSize(...DynamicTypeSize.large)
    }
    
    private func setupTuning() {
        if newChordGroupName.count == 0 {
            showNameFieldEmptyAlert.toggle()
        } else if selectedChords.count == 0 {
            showNoChordsSelectedAlert.toggle()
        } else {
            if let selectedTuning: Tuning = appStates.first!.tunings.first(where: { tuning in
                tuning.name == selectedTuningName
            }) {
                if let _ = selectedTuning.chordGroups.first(where: { $0.name.contains(newChordGroupName) }) {
                    showChordGroupNameExistsAlert.toggle()
                } else {
                    addNewChordGroup(selectedTuning: selectedTuning)
                    dismiss()
                }
            }
        }
    }
}

extension CreateChordGroupView {
    func addNewChordGroup(selectedTuning: Tuning) {
        // load all selected chord names into "-" separated string
        var chordNamesString = selectedChords.reduce(into: "", { $0 += $1.name + "-" })
        chordNamesString.removeLast()
        let newChordGroup = ChordGroup(name: newChordGroupName,
                                       availableChordNames: chordNamesString)
        newChordGroup.availableChords.append(contentsOf: selectedChords)
        if let firstChord = selectedChords.first {
            firstChord.group = newChordGroup
            appStates.first!.currentFretPositions = appStates.first!.activeChordFretMap
        }
        appStates.first!.activeTuning = selectedTuning
        appStates.first!.activeTuning?.chordGroups.append(newChordGroup)
        appStates.first!.activeTuning?.activeChordGroup = newChordGroup
        appStates.first!.pickerChordGroupName = newChordGroup.name
        appStates.first!.pickerTuningName = selectedTuning.name ?? ""
        appStates.first!.currentFretPositions = appStates.first!.activeChordFretMap
        try? modelContext.save()
        
        Logger.viewCycle.notice("Just Created New ChordGroup: \(newChordGroupName.description)")
    }
}


