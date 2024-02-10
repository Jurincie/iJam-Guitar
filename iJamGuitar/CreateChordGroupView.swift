//
//  CreateChordGroupView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 1/1/24.
//

import SwiftUI
import OSLog

struct CreateChordGroupView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var model: iJamViewModel
    @State private var chordGroupNameExistsAlert = false
    @State private var selectedChords: [Chord?] = Array(repeating: nil, count: 10)
    @State private var chordGroupName: String = ""
    @State private var currentTuning: Tuning?
    @State private var selectedChordIndex = 0

    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    let mySpacing = UIDevice.current.userInterfaceIdiom == .pad ? 18.0 : 12.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(0.6)

            VStack {
                Spacer()
                Text("New Group Name")
                    .font(.title)
                TextField("Enter Group Name", text: $chordGroupName)
                    .autocorrectionDisabled()
                    .padding()
                    .border(.black, width: 1, cornerRadius: 20)
                    .padding(.horizontal)
                Spacer()
                VStack {
                    Text("Select Tuning:")
                        .font(.headline)
                    VStack {
                        Menu {
                            Picker("Tunings", selection: $currentTuning) {
                                ForEach(model.getTuningNames(), id: \.self) {
                                    Text($0)
                                        .fixedSize()
                                }
                            }
                            .pickerStyle(.automatic)
                            .frame(maxWidth: .infinity)
                        } label: {
                            Text("\(model.activeTuningName)")
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
                .border(.black, width: 1, cornerRadius: 10)
                Spacer()
                Text("Tap on picks to select chords below")
                    .font(.headline)
                LazyVGrid(columns: columns,
                          spacing: mySpacing) {
                    ForEach(getUndefinedPicks(), id: \.id) { pick in
                        PickView(model: $model,
                                 pick: pick)
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
        var pickArray: [Pick] = []
        
        for index in 0..<10 {
            pickArray.append(Pick(id: index, 
                                  title: "",
                                  image: Image(index == selectedChordIndex ? .activePick : .blankPick)))
        }
        
        return pickArray
    }
    
//    func NewPickButton() -> some View {
//        ZStack {
//            // background
//            Image(named: "BlankPick")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(maxWidth: 100.0)
//                .padding(10)
//                .opacity(self.pick.title == kNoChordName ? 0.3 : 1.0)
//                .disabled(self.pick.title == kNoChordName)
//        }
//        
//        return button
//    }
}

#Preview {
    @State var model = iJamViewModel()
    return CreateChordGroupView(model: $model)
}

