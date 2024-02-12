//
//  HeaderView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/30/22.
//

import SwiftData
import SwiftUI
import OSLog

struct HeaderView: View {
    let width: CGFloat
    let height: CGFloat
    
    init(width: CGFloat, 
         height: CGFloat) {
        self.width = width
        self.height = height
    }

    var body: some View {
        VStack {
            Spacer()
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
                        TuningPickerView()
                        Spacer()
                        ChordGroupPickerView()
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        
    }
}
