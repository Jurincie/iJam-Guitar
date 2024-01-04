//
//  CreateChordGroupView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 1/1/24.
//

import SwiftUI

struct CreateChordGroupView: View {
    @Binding var model: iJamModel
    @State private var selectedChords: [Chord?] = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
    @State private var chordGroupName: String = ""
    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    let mySpacing = UIDevice.current.userInterfaceIdiom == .pad ? 18.0 : 12.0

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
        Text("CREATE NEW CHORD GROUP")
        Spacer()
        HStack {
            TuningPickerView(model: model)
            TextField("Enter Group Name", text: $chordGroupName)
        }
        Spacer()
        LazyVGrid(columns: columns, spacing:mySpacing) {
                ForEach(getPicks(), id: \.id) { pick in
                    PickView(model: $model,
                             pick: pick)
            }
        }
        Spacer()
    }
}

