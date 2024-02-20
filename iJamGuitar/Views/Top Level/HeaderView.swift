//
//  HeaderView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/30/22.
//

import SwiftData
import SwiftUI
import OSLog

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
    
    @Query private var appStates: [AppState]
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
                        TuningPickerView(tuningName: $tuningName, 
                                         chordGroupName: $chordGroupName)
                        Spacer()
                        ChordGroupPickerView(chordGroupName: $chordGroupName)
                        Spacer()
                        Button {
                            showCreateChordGroupSheet.toggle()
                        } label: {
                            VStack {
                                Spacer()
                                Spacer()
                                Image(systemName: "plus.circle")
                                    .font(.title)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                }
                .sheet(isPresented: $showCreateChordGroupSheet) {
                    CreateChordGroupView()
                }
            }
            Spacer()
        }
    }
}


