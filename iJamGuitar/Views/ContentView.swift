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
                           height: height * 0.14)
                .padding()
                TopView(width:width, height:height * 0.25)
                    .aspectRatio(contentMode: .fit)
                StringsAndFretsAreaView(width:width, height:height * 0.47)
                    .aspectRatio(contentMode: .fit)
                BottomView(width: width,
                           height:height * 0.14)
                .aspectRatio(contentMode: .fit)
            }
            .dynamicTypeSize(...DynamicTypeSize.medium)
            .cornerRadius(16.0)
            .frame(width:width,
                   height:height)
            .background(.ultraThinMaterial)
            .background(Color.black)
            .ignoresSafeArea()
            .onAppear() {
                UserDefaults.standard.setValue(UIDevice.current.userInterfaceIdiom == .pad,
                                               forKey: "IsIpad")
            }
        }
    }
}
    
#Preview {
    return ContentView()
        .modelContainer(AppStateContainer.create(false))
}
