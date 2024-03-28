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
    
    var body: some View {
        VStack {
            Spacer()
            Menu {
                Picker("Chord Groups", selection: $chordGroupName) {
                    if let appState = appStates.first {
                        let chordGroupNames = getChordGroupNamesForTuning(name: appState.activeTuning?.name ?? "")
                        ForEach(chordGroupNames, id: \.self) {
                            Text($0)
                        }
                        .onDelete(perform: deleteChordGroup)
                    }
                }
                .pickerStyle(.automatic)
                .onChange(of: chordGroupName, { oldValue, newValue in
                    Logger.viewCycle.notice("New ChordGroupname: \(newValue)")
                    appStates.first!.pickerChordGroupName = newValue
                    if let newChordGroup = appStates.first!.activeTuning?.chordGroups.first(where: { chordGroup in
                        chordGroup.name == newValue
                    }) {
                        appStates.first!.activeTuning?.activeChordGroup = newChordGroup
                        
                        let fretMap = appStates.first!.getFretIndexMap(fretMapString: newChordGroup.activeChord?.fretMapString ?? "")
                        
                        appStates.first!.currentFretPositions = fretMap
                    }
                })
            } label: {
                if let appState = appStates.first {
                    Text(appState.pickerChordGroupName)
                        .padding()
                        .font(UserDefaults.standard.bool(forKey: "IsIpad") ? .title2 : .caption)
                        .fontWeight(.semibold)
                        .background(Color.accentColor)
                        .foregroundColor(Color.primary)
                }
                
            }
            Spacer()
        }
        .frame(maxHeight: UserDefaults.standard.bool(forKey: "IsIpad") ? 48 : 36)
        .border(.white,
                width: 3)
        .cornerRadius(8)
    }
    
    func deleteChordGroup(at offsets: IndexSet) {
        appStates.first!.activeTuning?.chordGroups.remove(atOffsets: offsets)
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
