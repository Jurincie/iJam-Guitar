//
//  HeaderView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/30/22.
//

import SwiftUI
import OSLog

struct HeaderView: View {
    let viewModel = iJamViewModel.shared
    let width: CGFloat
    let height: CGFloat
    @State private var showAlert = false
    @State private var showCreateChordGroupView = false
    @State private var selectedTuningName: String {
        didSet {
            viewModel.activeTuningName = selectedTuningName
        }
    }
    @State private var selectedChordGroupName: String {
        didSet {
            viewModel.activeChordGroupName = selectedChordGroupName
        }
    }
    
    init(showAlert: Bool = false, 
         showCreateChordGroupView: Bool = false,
         width: CGFloat,
         height: CGFloat,
         selectedTuningName: String = "",
         selectedChordGroupName: String = ""){
        self.showAlert = showAlert
        self.showCreateChordGroupView = showCreateChordGroupView
        self.width = width
        self.height = height
        self.selectedTuningName = selectedTuningName
        self.selectedChordGroupName = selectedChordGroupName
    }

    var body: some View {
        ZStack() {
            // Background
            Image("HeaderView")
                .resizable()
                .frame(width: width, height: height)
            
            // Foreground
            VStack {
                Spacer()
                HStack() {
                    Spacer()
                    TuningPickerView(activeTuningName: $selectedTuningName)
                    Spacer()
                    ChordGroupPickerView(activeChordGroupName: $selectedChordGroupName)
                        
                    Spacer()
                }
                .padding()
            }
        }
    }
}
