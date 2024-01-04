//
//  ContentView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/24/23.
//

import SwiftUI
import SwiftData
import OSLog

struct ContentView: View {
    @Binding var dataModel: iJamModel
    var x: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geo in
            let height = geo.size.height
            let width = geo.size.width
            
            VStack(spacing: 0) {
                HeaderView(model: $dataModel, 
                           width: width,
                           height: height * 0.10 )
                    .aspectRatio(contentMode: .fit)
                TopView(model: $dataModel,
                        width:width,
                        height:height * 0.25)
                    .aspectRatio(contentMode: .fit)
                StringsAndFretsAreaView(dataModel: $dataModel,
                                        width:width,
                                        height:height * 0.50)
                    .aspectRatio(contentMode: .fit)
                BottomView(model: $dataModel,
                           width: width,
                           height:height * 0.15)
                    .aspectRatio(contentMode: .fit)
            }
            .dynamicTypeSize(...DynamicTypeSize.large)
            .cornerRadius(16.0)
            .frame(width:width, 
                   height:height)
        }
        .background(Color.black)
    }
}

#Preview {
    @State var model = iJamModel()
    
    return ContentView(dataModel: $model)
}

#Preview {
    @State var model = iJamModel()
    
    return ContentView(dataModel: $model)
        .environment(\.sizeCategory, .extraSmall)
}

#Preview {
    @State var model = iJamModel()
    
    return ContentView(dataModel: $model)
        .environment(\.sizeCategory, .accessibilityLarge)
}
