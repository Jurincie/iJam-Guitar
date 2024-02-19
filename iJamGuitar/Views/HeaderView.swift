//
//  HeaderView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/30/22.
//

import SwiftData
import SwiftUI
import OSLog
import Combine

enum Tunings: String {
    case standard = "Standard"
    case dropD = "DropD"
    case openD = "OpenD"
}

struct HeaderView: View {
    func getChordGroupNamesForTuning(name: String) -> [String] {
        var array = [String]()
        let thisTuning = appStates.first!.tunings.first { tuning in
            tuning.name == name
        }
        if let chordGroups = thisTuning?.chordGroups {
            for chordGroup in chordGroups {
                array.append(chordGroup.name)
            }
        }
        
        return array
    }
    
    @Query var appStates: [AppState]
    @State private var showCreateChordGroupSheet = false
    @State private var tuningName: String = ""
    @State private var chordGroupName: String = ""
    @State private var chordGroupNames = [String]()
    let width: CGFloat
    let height: CGFloat
    
    init(width: CGFloat,
         height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    var body: some View {
        VStack {
            Spacer()
            ZStack() {
                // Background
                Image(.secondView)
                    .resizable()
                    .frame(width: width, height: height)
                // Foreground
                VStack {
                    Text(" ") // Hack
                    Spacer()
                    HStack() {
                        Spacer()
                        // Tuning Picker
                        VStack {
                            Menu {
                                Picker("Tunings", selection: $tuningName) {
                                    let tuningNames = appStates.first!.getTuningNames()
                                    ForEach(tuningNames, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(.automatic)
                                .frame(maxWidth: .infinity)
                                .onChange(of: tuningName, { oldValue, newValue in
                                    Logger.viewCycle.notice("new Tuning name: \(newValue)")
                                    if let newTuning = appStates.first!.getTuning(name: newValue) {
                                        appStates.first!.makeNewTuningActive(newTuning: newTuning)
                                        chordGroupName = newTuning.activeChordGroup?.name ?? "Error-12"
                                    }
                                })
                            }
                        label: {
                            Text(appStates.first!.pickerTuningName)
                                .padding(10)
                                .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
                                .fontWeight(.semibold)
                                .background(Color.accentColor)
                                .foregroundColor(Color.white)
                                .shadow(color: .white , radius: 2.0)
                        }
                        }
                        .frame(alignment: .trailing)
                        .border(.white,
                                width: 2)
                        .padding(.top)
                        Spacer()
                        
                        VStack {
                            Menu {
                                Picker("Chord Groups", selection: $chordGroupName) {
                                    let chordGroupNames = getChordGroupNamesForTuning(name: appStates.first!.activeTuning?.name ?? "")
                                    ForEach(chordGroupNames, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .onChange(of: chordGroupName, { oldValue, newValue in
                                    Logger.viewCycle.notice("new ChordGroupname: \(newValue)")
                                    appStates.first!.pickerChordGroupName = newValue
                                    if let newChordGroup = appStates.first!.activeTuning?.chordGroups.first(where: { chordGroup in
                                        chordGroupName == newValue
                                    }) {
                                        appStates.first!.makeChordGroupActive(newChordGroup: newChordGroup)
                                        }
                                    })
                                    .pickerStyle(.automatic)
                                    .frame(maxWidth: .infinity)
                            }
                            label: {
                                Text(appStates.first!.pickerChordGroupName)
                                    .padding(10)
                                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
                                    .fontWeight(.semibold)
                                    .background(Color.accentColor)
                                    .foregroundColor(Color.white)
                                    .shadow(color: .white , radius: 2.0)
                            }
                        }
                        .frame(alignment: .leading)
                        .border(.white,
                                width: 2)
                        .padding(.top)
                        Spacer()
                        Button {
                            showCreateChordGroupSheet.toggle()
                        } label: {
                            VStack {
                                Spacer()
                                Image(systemName: "plus.circle")
                                    .font(.title)
                            }
                        }
                    }
                    .padding()
                }
            }
            Spacer()
        }
    }
}
    
    
