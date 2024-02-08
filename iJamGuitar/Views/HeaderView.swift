//
//  HeaderView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/30/22.
//

import SwiftUI
import OSLog

struct HeaderView: View {
    @State private var showAlert = false
    @State private var showCreateChordGroupView = false
    @Binding var model: iJamModel
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Spacer()
        ZStack() {
            // Background
            Image("HeaderView")
                .resizable()
                .frame(width: width, height: height)
            
            // Foreground
            VStack {
                Text(" ")
                HStack() {
                    Spacer()
                    TuningPickerView(model: model)
                        .frame(alignment: .trailing)
                        .border(.white,
                                width: 2,
                                cornerRadius: 7)
                        .padding(.top)
                    Spacer()
                    ChordGroupPickerView(model: $model)
                        .frame(alignment: .leading)
                        .border(.white,
                                width: 2,
                                cornerRadius: 7)
                        .padding(.top)
                    Spacer()
                }
                .padding()
            }
        }
    }
}
