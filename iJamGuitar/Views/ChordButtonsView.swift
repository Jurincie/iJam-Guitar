//
//  ChordButtonsView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/25/22.
//

import SwiftUI
import OSLog

struct ChordButtonsView: View {
    @Binding var model: iJamModel
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
        
    struct Pick: Identifiable  {
        var id: Int
        var title: String
        var image:Image
    }
    
    struct PickView: View {
        @Binding var model: iJamModel
        @State private var isAnimated: Bool = false
        let noChordArray = [Int](repeating: -1, count: 10)
        let kNoChordName = "NoChord"
        var pick: Pick
        
        var body: some View {
            ZStack() {
                // background layer
                PickButton()
                
                // front layer
                Text(self.pick.title == kNoChordName ? "" : self.pick.title)
                    .foregroundColor(Color.white)
                    .font(.custom("Arial Rounded MT Bold", size: getFontSize(targetString: self.pick.title)))
                    .fontWeight(.bold)
            }
            .cornerRadius(10.0)
            .scaleEffect(isAnimated ? 2.0 : 1.0)
        }
        
        func PickButton() -> some View {
           let button =  Button(action: {
               if model.selectedChordIndex != pick.id || chordIsAltered(pick.id) {
                    withAnimation(.default) {
                        isAnimated.toggle()
                    }
                    makeChosenPicksChordActive()
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
            if model.selectedChordIndex == self.pick.id {
                let thisChord = model.availableChords[self.pick.id]
                pickImageName = model.fretIndexMap != model.getFretIndexMap(chord: thisChord) ? "ModifiedPick" : "ActivePick"
            } else {
                pickImageName = self.pick.id < model.availableChords.count ? "BlankPick" : "UndefinedPick"
            }
            
            return pickImageName
        }
        
        func chordIsAltered(_ chordIndex: Int) -> Bool {
            let thisChord = model.availableChords[chordIndex]
            return model.fretIndexMap != model.getFretIndexMap(chord: thisChord)
        }
        
        /// sets model.activeChord and model.selectedIndex
        func makeChosenPicksChordActive() {
            isAnimated.toggle()
            
            if let chordNames = model.activeChordGroup?.availableChordNames.components(separatedBy: ["-"]) {
                guard self.pick.id < chordNames.count else { return }
                
                let newActiveChordName = chordNames[self.pick.id]
                if let newActiveChord = model.getChord(name: newActiveChordName, 
                                                       tuning: model.activeTuning) {
                    model.activeChord = newActiveChord
                    model.selectedChordIndex = self.pick.id
                }
            }
        }
        
        func getFontSize(targetString: String) -> Double {
            switch targetString.count {
            case 1:     return UIDevice.current.userInterfaceIdiom == .pad ? 28.0 : 22.0
            case 2:     return UIDevice.current.userInterfaceIdiom == .pad ? 26.0 : 20.0
            case 3:     return UIDevice.current.userInterfaceIdiom == .pad ? 24.0 : 18.0
            case 4,5:  return UIDevice.current.userInterfaceIdiom == .pad ? 18.0 : 14.0
            default:    return UIDevice.current.userInterfaceIdiom == .pad ? 14.0 : 10.0
            }
        }
    }
}

