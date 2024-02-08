//
//  Extensions.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/8/22.
//

import Foundation
import SwiftUI

extension View {
    func readFrame(onChange: @escaping (CGRect) -> ()) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: FramePreferenceKey.self,
                                value: geometryProxy.frame(in: .global))
            }
        )
        .onPreferenceChange(FramePreferenceKey.self, perform: onChange)
    }
}
