//
//  CreateChordGroupPickView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 2/19/24.
//

import SwiftData
import SwiftUI
import OSLog

struct CreateChordGroupPickView: View {
    @Query var appStates: [AppState]
    @Binding var selectedChords: [Chord]
    var pick: Pick
    
    var body: some View {
        ZStack() {
            // background
            Image(pick.id < selectedChords.count ? .activePick : .blankPick)
                .resizable()
                .scaledToFill()
            
            // foreground
            Text(pick.id < selectedChords.count ? selectedChords[pick.id].name : "")
                .foregroundColor(Color.primary)
                .font(.headline)
                .fontWeight(.bold)
        }
        .cornerRadius(10.0)
    }
}
