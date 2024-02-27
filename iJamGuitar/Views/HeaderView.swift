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
            Spacer()
            Spacer()
            HStack {
                Spacer()
                TuningPickerView(tuningName: $tuningName,
                                 chordGroupName: $chordGroupName)
                    .border(.white,
                            width: 2)
                    .cornerRadius(7)
                    .padding(.top)
                Spacer()
                ChordGroupPickerView(chordGroupName: $chordGroupName)
                    .border(.white,
                            width: 2)
                    .cornerRadius(7)
                    .padding(.top)
                Spacer()
                Button(action: {
                    showCreateChordGroupSheet.toggle()
                }, label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .padding(.top)
                })
            }
            .sheet(isPresented: $showCreateChordGroupSheet) {
                CreateChordGroupView()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background() {
            Color(.black)
                .frame(width: width, height: height)
        }
    }
    
    func getChordGroupNamesForTuning(name: String) -> [String] {
        guard let appState = appStates.first else { return [] }
        
        var chordGroupNameArray = [String]()
        let thisTuning = appState.tunings.first { tuning in
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
    return HeaderView(width: .infinity, 
                      height: 200)
}



                    


