//
//  PickView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 1/28/24.
//

import SwiftData
import SwiftUI
import OSLog

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
    
    var body: some View {
        ZStack() {
            // background layer
            PickButton()
            
            // top layer
            Text(self.pick.title == kNoChordName ? "" : self.pick.title)
                .foregroundColor(Color.white)
                .font(.custom("Arial Rounded MT Bold", size: getFontSize(targetString: self.pick.title)))
                .fontWeight(.bold)
        }
        .cornerRadius(10.0)
        .scaleEffect(isAnimated ? 2.0 : 1.0)
    }
}

extension PickView {
    func PickButton() -> some View {
        let button =  Button(action: {
            let fretMapChanged = chordIsAltered()
            if appStates.first!.selectedChordIndex != pick.id || fretMapChanged {
               appStates.first!.setNewActiveChordFromPickIndex(pick.id)
            }
        }){
            Image(getPickImageName())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 100.0)
                .padding(10)
                .opacity(self.pick.title == kNoChordName ? 0.3 : 1.0)
                .disabled(self.pick.title == kNoChordName)
        }
        
        return button
    }
    
    // returns approprieate imageName for pickButton or "BlankPick" on failure
    func getPickImageName() -> String {
        var pickImageName = "BlankPick"
        if appStates.first!.selectedChordIndex == pick.id {
            let thisChord = appStates.first!.activeChordGroup?.availableChords[pick.id]
            pickImageName = appStates.first!.currentFretIndexMap != appStates.first!.getFretIndexMap(chord: thisChord) ? "ModifiedPick" : "ActivePick"
        } else {
            pickImageName = pick.id < appStates.first!.activeChordGroup?.availableChords.count ?? 0 ? "BlankPick" : "UndefinedPick"
        }
        
        return pickImageName
    }
    
    func chordIsAltered() -> Bool {
        if let thisChord = appStates.first!.activeChordGroup?.availableChords[pick.id] {
            return appStates.first!.currentFretIndexMap != appStates.first!.getFretIndexMap(chord: thisChord)
        }
        
        return false
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

