//
//  HeaderView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/30/22.
//

import SwiftUI
import OSLog

struct HeaderView: View {
    @Binding var model: iJamModel
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack() {
            // background
            Image("HeaderView")
                .resizable()
                .frame(width: width, height: height)
                .border(Color.gray, width: 2)
            // Foreground
            HStack() {
                Spacer()
                TuningPickerView(model: $model)
                    .frame(alignment: .trailing)
                    .border(.white, 
                            width: 2,
                            cornerRadius: 7)
                Spacer()
                ChordGroupPickerView(model: $model)
                    .frame(alignment: .leading)
                    .border(.white,
                            width: 2,
                            cornerRadius: 7)
                Spacer()
            }
        }
    }
}

//struct Previews_HeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeaderView(width: 300.0, height: 75.0)
//            .previewLayout(.sizeThatFits)
//    }
//}
