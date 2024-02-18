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
    @State private var showCreateChordGroupSheet = false
    @Query var appStates: [AppState]
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }

    var body: some View {
        VStack {
            Spacer()
            ZStack() {
                // Background
                Image(.secondView)
                    .resizable()
                    .frame(width: width, height: height)
                
                // Foreground
                VStack {
                    Text(" ") // Hack
                    Spacer()
                    HStack() {
                        Spacer()
                        TuningPickerView()
                            .frame(alignment: .trailing)
                            .border(.white,
                                    width: 2,
                                    cornerRadius: 7)
                            .padding(.top)
                        Spacer()
                        ChordGroupPickerView()
                            .frame(alignment: .leading)
                            .border(.white,
                                    width: 2,
                                    cornerRadius: 7)
                            .padding(.top)
                        Spacer()
                        Button {
                            showCreateChordGroupSheet.toggle()
                        } label: {
                            VStack {
                                Spacer()
                                Image(systemName: "plus.circle")
                                    .font(.title)
                            }
                        }

                        Spacer()
                    }
                    .padding()
                }
            }
            Spacer()
        }
    }
}
