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
            .opacity(blinking ? 0.85 : 1.0)
            .border(.red, width: blinking ? 1 : 4)
            .onAppear {
                withAnimation(.easeInOut(duration: duration).repeatForever()) {
                    blinking = true
                }
            }
    }
}



