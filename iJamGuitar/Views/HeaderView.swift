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
                TuningPickerView(tuningName: $tuningName,
                                 chordGroupName: $chordGroupName)
                    .border(.white,
                            width: 2)
                    .cornerRadius(7)
                    .padding(.horizontal)
                ChordGroupPickerView(chordGroupName: $chordGroupName)
                    .border(.white,
                            width: 2)
                    .cornerRadius(7)
                Spacer()
                Button(action: {
                    showCreateChordGroupSheet.toggle()
                }, label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                })
            }
            .sheet(isPresented: $showCreateChordGroupSheet) {
                CreateChordGroupView()
            }
        }
        .border(.clear)
        .background() {
            Color(.black)
                .frame(width: width, height: height)
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
    HeaderView(width: 500,
               height: 200)
    .modelContainer(for: AppState.self)
}



                    


