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
    @Environment(\.modelContext) var modelContext
    var x: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geo in
            let height = geo.size.height
            let width = geo.size.width
            
            VStack(spacing: 0) {
                HeaderView(width: width,
                           height: height * 0.14)
                .padding()
                TopView(width:width,
                        height:height * 0.25)
                .aspectRatio(contentMode: .fit)
                StringsAndFretsAreaView(width:width,
                                        height:height * 0.50)
                .aspectRatio(contentMode: .fit)
                BottomView(width: width,
                           height:height * 0.11)
                .aspectRatio(contentMode: .fit)
            }
            .dynamicTypeSize(...DynamicTypeSize.large) // Clamps available sizes
            .cornerRadius(16.0)
            .frame(width:width,
                   height:height)
        }
        .background(Color.black)
        .ignoresSafeArea()
    }
}

#Preview {
    return ContentView()
        .modelContainer(AppStateContainer.create(true))
        .preferredColorScheme(.dark)
}

#Preview {
    return ContentView()
        .modelContainer(AppStateContainer.create(true))
        .preferredColorScheme(.light)
}

#Preview {
    return ContentView()
        .modelContainer(AppStateContainer.create(true))
        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
}
