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

struct TextFieldView: View {
    @Binding var newChordGroupName: String
    @FocusState private var isChordNewChordGroupNameFocused: Bool

    var body: some View {
        TextField("Enter Group Name", text: $newChordGroupName)
            .focused($isChordNewChordGroupNameFocused)
            .textFieldStyle(CustomTextFieldStyle())
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .border(.black, width: 1)
            .padding()
            .padding(.horizontal)
            .onAppear() {
                // set first responder here
                isChordNewChordGroupNameFocused = true
            }
    }
}

struct CreateChordGroupView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Query var appStates: [AppState]
        
    // State Properties
    @State private var shouldAnimate = false
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
        VStack(alignment: .center) {
            Text("Create Chord Group")
                .font(.headline)
            Spacer()
            TextFieldView(newChordGroupName: $newChordGroupName)
                
            VStack {
                LazyVGrid(columns: columns,
                          spacing: 8) {
                    ForEach(getUndefinedPicks(), id: \.id) { pick in
                        CreateChordGroupPickView(selectedChords: $selectedChords, pick: pick)
                    }
                }
                
                Menu {
                    Picker("Tunings", selection: $selectedTuningName) {
                        ForEach(appStates.first!.getTuningNames(), id: \.self) {
                            Text($0)
                                .font(.caption)
                        }
                    }
                    .onChange(of: selectedTuningName, { oldValue, newValue in
                        selectedChords.removeAll()
                    })
                    .pickerStyle(.automatic)
                    .frame(maxWidth: .infinity)
                }
            label: {
                if selectedTuningName == "Select a Tuning" {
                    Text(selectedTuningName)
                        .padding()
                        .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
                        .fontWeight(.semibold)
                        .background(Color.accentColor)
                        .foregroundColor(Color.white)
                        .shadow(color: .white , radius: 2.0)
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
            .modifier(BlinkingModifier(duration:0.5))
            .cornerRadius(10)
            .padding()
                Spacer()
                Text(selectedTuningName == "Select a Tuning" ? "" : "Choose up to 10 chords (below)")
                    .font(.headline)
                    .foregroundColor(.black)
                AvailableChordsGridView(selectedTuningName: $selectedTuningName,
                                        selectedChords: $selectedChords,
                                        tuningSelected: selectedTuningName != "Select a Tuning")
            }
            Spacer()
            HStack {
                Button(action: {
                    dismiss()
                }, label: { Text("CANCEL")})
                .frame(alignment: .bottom)
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                Spacer()
                Button(action: {
                    guard selectedTuningName != "Select a Tuning" else {  showNameTuningUndefinedAlert.toggle()
                        return
                    }
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
                }, label: { Text("SUBMIT")})
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Image(.topView)
            .resizable()
            .scaledToFill()
            .opacity(0.2))
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
        newChordGroup.availableChords.append(contentsOf: selectedChords)
        if let firstChord = selectedChords.first {
            firstChord.group = newChordGroup
            
            let fretMapString = firstChord.fretMapString
            appStates.first!.currentFretIndexMap = appStates.first!.getFretIndexMap(fretMapString: fretMapString)
        }
        appStates.first!.activeTuning = selectedTuning
        appStates.first!.activeTuning?.chordGroups.append(newChordGroup)
        appStates.first!.activeTuning?.activeChordGroup = newChordGroup
        appStates.first!.pickerChordGroupName = newChordGroup.name
        appStates.first!.pickerTuningName = selectedTuning.name ?? ""
        try? modelContext.save()
        
        Logger.viewCycle.debug("Just Created New ChordGroup: \(newChordGroupName.description)")
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

struct AnimationValues {
    var scale = 1.0
    var verticalStretch = 1.0
}


