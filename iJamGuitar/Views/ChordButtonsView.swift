//
//  ChordButtonsView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/25/22.
//

import SwiftData
import SwiftUI
import OSLog

struct ChordButtonsView: View {
    @Query var appStates: [AppState]
    let width: CGFloat
    let height: CGFloat
    let mySpacing = UIDevice.current.userInterfaceIdiom == .pad ? 18.0 : 12.0
    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    
    func getPicks() -> [Pick] {
        guard let appState = appStates.first else { return [] }

        var pickArray = [Pick]()
        var chordNames = appStates.first!.activeChordGroup?.availableChordNamesArray
        // append "NoChord" to fill chordNames to 10
        if let numberNames = chordNames?.count {
            for _ in numberNames..<10 {
                chordNames?.append("NoChord")
            }
        }
        
        for index in 0..<10 {
            let title = chordNames?[index] ?? ""
            if let thisChord = appState.activeChordGroup?.availableChords.first(where: { chord in
                chord.name == title }) {
                pickArray.append(Pick(id: index,
                                      chord: thisChord,
                                      image:Image("UndefinedPick")))
            }
        }

        return pickArray
    }
            
    var body: some View {
        let pickArray = getPicks()
        LazyVGrid(columns: columns, spacing:mySpacing) {
                ForEach(pickArray, id: \.id) { pick in
                    PickView(pick: pick)
            }
        }
    }
}

