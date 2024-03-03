//
//  BlinkingModifier.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 2/21/24.
//

import SwiftUI

struct BlinkingModifier: ViewModifier {
    let duration: Double
    @State private var blinking: Bool = false
    
    func body(content: Content) -> some View {
        content
            .opacity(blinking ? 0.7 : 1.0)
            .onAppear {
                withAnimation(.easeOut(duration: duration).repeatForever()) {
                    blinking = true
                }
            }
    }
}



