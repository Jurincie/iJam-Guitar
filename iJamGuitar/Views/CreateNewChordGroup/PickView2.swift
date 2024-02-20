//
//  CreateChordGroupPickView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 2/19/24.
//

import SwiftData
import SwiftUI
import OSLog

struct PickView2: View {
    @Query var appStates: [AppState]
    @Binding var selectedChordIndex: Int
    @State private var isTapped: Bool = false
    let kNoChordName = "NoChord"
    var pick: Pick
    
    var body: some View {
        ZStack() {
            // background
            PickButton()
            
            // foreground
            Text(pick.chord.name == kNoChordName ? "" : pick.chord.name)
                .foregroundColor(Color.white)
                .font(.headline)
                .fontWeight(.bold)
        }
        .scaleEffect(isTapped ? 2.0 : 1.0)
        .cornerRadius(10.0)
    }
}

extension PickView2 {
    func PickButton() -> some View {
        let button =  Button(action: {
            withAnimation(.default) {
                isTapped.toggle()
            }
            selectedChordIndex = pick.id
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
    
    func getPickImageName() -> String {
        let pickImageName = "BlankPick"
        
        return pickImageName
    }
}

//
//#Preview {
//    CreateChordGroupPickView()
//}
