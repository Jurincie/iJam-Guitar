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
    var chord: Chord
    var image:Image
}

struct PickView: View {
    @Query var appStates: [AppState]
    @State private var isTapped: Bool = false
    @State private var scaleValue = 1.0
    let kNoChordName = "NoChord"
    var pick: Pick
    var chord = Chord(name: "", fretMapString: "")
    
    var body: some View {
        ZStack() {
            // background layer
            PickButton()
            
            // top layer
            Text(pick.chord.name == kNoChordName ? "" : pick.chord.name)
                .foregroundColor(Color.white)
                .font(.headline)
                .fontWeight(.bold)
        }
        .cornerRadius(10.0)
        .scaleEffect(isTapped ? 2.0 : 1.0)
    }
}

extension PickView {
    func PickButton() -> some View {
        let button =  Button(action: {
            withAnimation(.default) {
                isTapped.toggle()
            }
            appStates.first!.activeChordGroup?.activeChord = pick.chord
            appStates.first!.currentFretIndexMap = appStates.first!.getFretIndexMap(fretMapString: pick.chord.fretMapString)
            isTapped.toggle()
        }){
            Image(getPickImageName())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 100.0)
                .padding(10)
                .opacity(pick.chord.name == kNoChordName ? 0.3 : 1.0)
                .disabled(pick.chord.name == kNoChordName)
        }

        return button
    }
    
    // returns approprieate imageName for pickButton or "BlankPick" on failure
    func getPickImageName() -> String {
        let numberAvailableChords = appStates.first!.activeChordGroup?.availableChords.count
        var pickImageName = "BlankPick"
        
        if appStates.first!.activeChordGroup?.activeChord == pick.chord {
            pickImageName = appStates.first!.currentFretIndexMap != appStates.first!.getFretIndexMap(fretMapString: pick.chord.fretMapString) ? "ModifiedPick" : "ActivePick"
        } else {
            pickImageName = pick.id < numberAvailableChords ?? 0 ? "BlankPick" : "UndefinedPick"
        }
        
        return pickImageName
    }
}

