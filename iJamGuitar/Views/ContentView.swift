//
//  ContentView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/24/23.
//

import SwiftData
import SwiftUI
import OSLog

struct ContentView: View {
    var body: some View {
        GeometryReader { geo in
            let height = geo.size.height
            let width = geo.size.width
            
            VStack(spacing: 0) {
                HeaderView(width: width,
                           height: height * 0.12)
                TopView(width:width,
                        height:height * 0.25)
                StringsAndFretsAreaView(width:width,
                                        height:height * 0.43)
                BottomView(width: width,
                           height:height * 0.20)
            }
            .ignoresSafeArea()
            .minimumScaleFactor(0.6)
            .cornerRadius(16.0)
            .frame(width:width,
                   height:height)
            .background(Color.black)
        }
    }
}
    
#Preview {
    return ContentView()
        .modelContainer(AppStateContainer.create(false))
}
