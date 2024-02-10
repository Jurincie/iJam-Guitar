//
//  ChordButtonsView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/25/22.
//

import SwiftUI
import OSLog

struct ChordButtonsView: View {
    @Binding var model: iJamViewModel
    let width: CGFloat
    let height: CGFloat
    let mySpacing = UIDevice.current.userInterfaceIdiom == .pad ? 18.0 : 12.0
    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    
    func getPicks() -> [Pick] {
        let chordNames:[String] = model.getAvailableChordNames(activeChordGroup: model.activeChordGroup)
        var pickArray: [Pick] = []
        
        for index in 0..<10 {
            pickArray.append(Pick(id: index, title: chordNames[index], 
                                  image:Image("UndefinedPick")))
        }
        
        return pickArray
    }
            
    var body: some View {
        LazyVGrid(columns: columns, spacing:mySpacing) {
                ForEach(getPicks(), id: \.id) { pick in
                    PickView(model: $model, 
                             pick: pick)
            }
        }
    }
}

