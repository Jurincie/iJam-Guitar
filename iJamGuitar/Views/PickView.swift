//
//  PickView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 1/28/24.
//

import SwiftData
import SwiftUI

struct Pick: Identifiable  {
    var id: Int
    var title: String
    var image:Image
}

struct PickView: View {
    @Query var appStates: [AppState]
    @State private var isAnimated: Bool = false
    let kNoChordName = "NoChord"
    var pick: Pick
    var appState: AppState
    
    var body: some View {
        ZStack() {
            PickButton()
            // background layer
            
            // top layer
            Text(self.pick.title == kNoChordName ? "" : self.pick.title)
                .foregroundColor(Color.white)
                .font(.custom("Arial Rounded MT Bold", 
                              size: getFontSize(targetString: self.pick.title)))
        }
        .cornerRadius(10.0)
        .scaleEffect(isAnimated ? 3.0 : 1.0)
    }
}

extension PickView {
    func PickButton() -> some View {
        let button =  Button(action: {
            if appState.selectedChordIndex != pick.id || chordIsAltered(pick.id) {
                withAnimation(.default) {
                    isAnimated.toggle()
                }
                makeChosenPicksChordActive()
            }
        }){
            if let availableChords = appState.activeChordGroup?.availableChords {
                Image(getPickImageName(availableChords: availableChords,
                                       selectedChordIndex: appState.selectedChordIndex))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 100.0)
                    .padding(10)
                    .opacity(self.pick.title == kNoChordName ? 0.3 : 1.0)
                    .disabled(self.pick.title == kNoChordName)
            }
        }
            
        return button
    }
    
    // returns approprieate imageName for pickButton or "BlankPick" on failure
    func getPickImageName(availableChords: [Chord],
                          selectedChordIndex: Int) -> String {
        var pickImageName = "BlankPick"
        
        if selectedChordIndex == self.pick.id {
            let thisChord = availableChords[self.pick.id]
            pickImageName = appState.currentFretIndexMap != appState.getFretIndexMap(chord: thisChord) ? "ModifiedPick" : "ActivePick"
        } else {
            pickImageName = self.pick.id < availableChords.count ? "BlankPick" : "UndefinedPick"
        }
        
        return pickImageName
    }
    
    func chordIsAltered(_ chordIndex: Int) -> Bool {
        let thisChord = appState.activeChordGroup?.availableChords[chordIndex]
        return appState.currentFretIndexMap != appState.getFretIndexMap(chord: thisChord)
    }
    
    /// sets model.activeChord and model.selectedIndex
    func makeChosenPicksChordActive() {
        isAnimated.toggle()
        
        if let chordNames = appState.activeChordGroup?.availableChordNames {
            guard self.pick.id < chordNames.count else { return }
            
            let newActiveChordName = chordNames[self.pick.id]
            if let newActiveChord = appStates.first?.getChord(name: newActiveChordName,
                                                              tuning: appState.activeTuning) {
                appState.activeTuning?.activeChordGroup?.activeChord = newActiveChord
                appState.selectedChordIndex = self.pick.id
            }
        }
    }
    
    /// Calculates an appropriate font size depending on device and length of targetString
    func getFontSize(targetString: String) -> Double {
        switch targetString.count {
        case 1:     return UIDevice.current.userInterfaceIdiom == .pad ? 28.0 : 22.0
        case 2:     return UIDevice.current.userInterfaceIdiom == .pad ? 26.0 : 20.0
        case 3:     return UIDevice.current.userInterfaceIdiom == .pad ? 24.0 : 18.0
        case 4,5:   return UIDevice.current.userInterfaceIdiom == .pad ? 18.0 : 14.0
        default:    return UIDevice.current.userInterfaceIdiom == .pad ? 14.0 : 10.0
        }
    }
}

//#Preview {
//    @State var model = iJamModel()
//    PickView(model: $model)
//}
