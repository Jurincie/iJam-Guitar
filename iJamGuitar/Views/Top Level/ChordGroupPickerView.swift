//
//  .swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 2/19/24.
//

import OSLog
import SwiftData
import SwiftUI


struct ChordGroupPickerView: View {
    @Query var appStates: [AppState]
    @Binding var chordGroupName: String
    var height: CGFloat
    
    var body: some View {
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
                        chordGroup.name == newValue
                    }) {
                        appStates.first!.activeTuning?.activeChordGroup = newChordGroup
                        
                        let fretMap = appStates.first!.getFretIndexMap(fretMapString: newChordGroup.activeChord?.fretMapString ?? "")
                        
                        appStates.first!.currentFretIndexMap = fretMap
                    }
                })
                .pickerStyle(.automatic)
                .frame(maxWidth: .infinity)
            } label: {
                Text(appStates.first!.pickerChordGroupName)
                    .padding()
                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
                    .fontWeight(.semibold)
                    .background(Color.accentColor)
                    .foregroundColor(Color.white)
                    .shadow(color: .white , radius: 2.0)
            }
        }
        .frame(height: height, alignment: .leading)
        .border(.white,
                width: 3)
        .cornerRadius(8)
        .padding(.top)
    }
    
    func deleteChordGroup() {
        Logger.viewCycle.debug("Here we delete a chord group")
        Logger.viewCycle.debug("Do not allow LAST remaining group to be deletee")
    }
    
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
}

//#Preview {
//    ChordGroupPickerView(chordGroupName: Binding<"Key of G">)
//}
