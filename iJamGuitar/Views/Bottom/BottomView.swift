//
//  BottomView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 4/25/22.
//

import SwiftData
import SwiftUI
import OSLog

struct BottomView: View {    
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack() {
            Image(.bottomView)
                .resizable()
                .frame(width:width,
                       height:height,
                       alignment:.topLeading)
            HStack {
                VolumeView()
                Divider()
                    .frame(width: 3.0, height: 30.0)
                    .background(Color.white)
                CapoView()
            }
            .padding(.top, 20.0)
            .padding()
        }
    }
}
