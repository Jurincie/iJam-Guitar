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
    @Query private var appStates: [AppState]
    @State private var showCreateChordGroupSheet = false
    @State private var tuningName: String = ""
    @State private var chordGroupName: String = ""
    @State private var chordGroupNames = [String]()
    let backgroundImage = Image(.thirdView)
    let width: CGFloat
    let height: CGFloat
    
    init(width: CGFloat,
         height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    var body: some View {
        VStack {
            HStack() {
                Spacer()
                TuningPickerView(tuningName: $tuningName, chordGroupName: $chordGroupName, height: height / 4)
                Spacer()
                Spacer()
                ChordGroupPickerView(chordGroupName: $chordGroupName, height: height / 4)
                Spacer()
                Spacer()
                Button {
                    showCreateChordGroupSheet.toggle()
                } label: {
                    VStack {
                        Spacer()
                        Spacer()
                        Spacer()
                        Image(systemName: "plus.circle")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
            }
            .padding(.vertical)
            .frame(maxHeight: 80)
        }
        .padding()
        .background(backgroundImage
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .opacity(0.60))
        
        .sheet(isPresented: $showCreateChordGroupSheet) {
            CreateChordGroupView()
        }
    }
    
    func getChordGroupNamesForTuning(name: String) -> [String] {
        var chordGroupNameArray = [String]()
        let thisTuning = appStates.first!.tunings.first { tuning in
            tuning.name == name
        }
        if let chordGroups = thisTuning?.chordGroups {
            for chordGroup in chordGroups {
                chordGroupNameArray.append(chordGroup.name)
            }
        }
        
        return chordGroupNameArray
    }
}

#Preview {
    return HeaderView(width: .infinity, height: 200)
}


