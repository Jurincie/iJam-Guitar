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
        let chordNames:[String] = appStates.first!.activeChordGroup?.getAvailableChordNames() ?? []
        var pickArray: [Pick] = []
        
        for index in 0..<chordNames.count {
            pickArray.append(Pick(id: index, title: chordNames[index],
                                  image:Image("UndefinedPick")))
        }
        
        return pickArray
    }
            
    var body: some View {
        LazyVGrid(columns: columns, spacing:mySpacing) {
                ForEach(getPicks(), id: \.id) { pick in
                    PickView(pick: pick)
            }
        }
    }
}

//struct ChordButtonsView: View {
//    @Query var appStates: [AppState]
//    let width: CGFloat
//    let height: CGFloat
//    let mySpacing = UIDevice.current.userInterfaceIdiom == .pad ? 18.0 : 12.0
//    let columns = Array(repeating: GridItem(.flexible()), count: 5)
//    
//    func getPicks() -> [Pick] {
//        let appState = appStates.first!
//        let thisChordGroup: ChordGroup? = appState.getChordGroup(name: appState.activeChordGroupName)
//        let chordNames:[String] = appState.getAvailableChordNames(activeChordGroup: thisChordGroup)
//        var pickArray: [Pick] = []
//        
//        for index in 0..<10 {
//            pickArray.append(Pick(id: index, title: chordNames[index], 
//                                  image:Image("UndefinedPick")))
//        }
//        
//        return pickArray
//    }
//            
//    var body: some View {
//        LazyVGrid(columns: columns, spacing: mySpacing) {
//                ForEach(getPicks(), id: \.id) { pick in
//                    PickView(pick: pick)
//            }
//        }
//    }
//}

