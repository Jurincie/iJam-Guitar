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
    
    // Alert State Properties
    @State private var showNameFieldEmptyAlert = false
    @State private var showNoChordsSelectedAlert = false
    @State private var showChordGroupNameExistsAlert = false
    @State private var showNameTuningUndefinedAlert = false
    
    // State Properties
    @State private var selectedChords = [Chord]()
    @State private var newChordGroupName: String = ""
    @State var selectedTuningName: String = "Select a Tuning"
    
    // Calculated Property
    var tuningSelected: Bool {
        selectedTuningName != "Select a Tuning"
    }
    var spacing: Double {
        UserDefaults.standard.bool(forKey: "IsIpad") ? 10.0 : 5.0
    }
    
    var body: some View {
        VStack(alignment: .center) {
            TextFieldView(newChordGroupName: $newChordGroupName)
            VStack {
                GridView(selectedChords: $selectedChords)
                PickerView(tuningSelected: tuningSelected, 
                           selectedTuningName: $selectedTuningName,
                           selectedChords: $selectedChords)
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
                    guard tuningSelected else { showNameTuningUndefinedAlert.toggle(); return }
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
        var chordNamesString = selectedChords.reduce(into: "", { $0 += $1.name + "-" })
        chordNamesString.removeLast()
        let newChordGroup = ChordGroup(name: newChordGroupName,
                                       availableChordNames: chordNamesString)
        newChordGroup.availableChords.append(contentsOf: selectedChords)
        if let firstChord = selectedChords.first {
            firstChord.group = newChordGroup
            
            let fretMapString = firstChord.fretMapString
            appStates.first!.currentFretPositions = appStates.first!.getFretIndexMap(fretMapString: fretMapString)
        }
        appStates.first!.activeTuning = selectedTuning
        appStates.first!.activeTuning?.chordGroups.append(newChordGroup)
        appStates.first!.activeTuning?.activeChordGroup = newChordGroup
        appStates.first!.pickerChordGroupName = newChordGroup.name
        appStates.first!.pickerTuningName = selectedTuning.name ?? ""
        try? modelContext.save()
        
        Logger.viewCycle.notice("Just Created New ChordGroup: \(newChordGroupName.description)")
    }
}

struct PickerView: View {
    @Query var appStates: [AppState]
    var tuningSelected: Bool
    @Binding var selectedTuningName: String
    @Binding var selectedChords: [Chord]
    var body: some View {
        Menu {
            Picker("Tunings", selection: $selectedTuningName) {
                ForEach(appStates.first!.getTuningNames(), id: \.self) {
                    Text($0)
                        .font(.caption)
                }
            }
            .onChange(of: selectedTuningName, { oldValue, newValue in
                // when user changes tuning selection:
                //  -> remove all the selectedChords with earlier tuning
                selectedChords.removeAll()
            })
            .pickerStyle(.inline)
            .frame(maxWidth: .infinity)
        } label: {
            Text(selectedTuningName)
                .padding()
                .foregroundColor(.white)
                .font(UserDefaults.standard.bool(forKey: "IsIpad") ? .title2 : .caption)
                .background(Color.accentColor)
                .modifier(BlinkingModifier(duration: tuningSelected ? 0.0 : 0.6))
        }
        .cornerRadius(10)
        Text(tuningSelected == false ? "" : "Choose up to 10 chords (below)")
            .font(.headline)
            .foregroundColor(.primary)
    }
}

struct TextFieldView: View {
    @Binding var newChordGroupName: String
    
    var body: some View {
        Text("Create Chord Group")
            .foregroundStyle(Color.white)
            .font(.title)
        TextField("Enter Group Name", text: $newChordGroupName)
            .textFieldStyle(CustomTextFieldStyle())
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .border(.black, width: 2)
            .padding(.horizontal)
            .font(.headline)
    }
}

struct CustomTextFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.title) // set the inner Text Field Font
            .padding(5) // Set the inner Text Field Padding
        //Give it some style
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color.primary.opacity(0.5), lineWidth: 1))
    }
}

struct GridView: View {
    @Binding var selectedChords: [Chord]
    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    
    var body: some View {
        LazyVGrid(columns: columns,
                  spacing: 8) {
            let picks = getUndefinedPicks()
            ForEach(picks, id: \.id) { pick in
                CreateChordGroupPickView(selectedChords: $selectedChords, pick: pick)
            }
        }
        Divider()
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

struct AnimationValues {
    var scale = 1.0
    var verticalStretch = 1.0
}


