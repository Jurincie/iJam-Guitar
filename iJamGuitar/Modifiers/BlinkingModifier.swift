//
//  BlinkingModifier.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 2/21/24.
//

import SwiftUI

struct BlinkingModifier: ViewModifier {
    @State private var blinking: Bool = false
    let duration: Double
    
    init(duration: Double) {
        self.duration = duration
    }
    
    func body(content: Content) -> some View {
        if duration == 0.0 {
            content
        } else {
            content
                .opacity(blinking ? 0.85 : 1.0)
                .border(.red, width: blinking ? 0 : 6)
                .onAppear {
                    withAnimation(.easeInOut(duration: duration).repeatForever()) {
                        blinking = true
                }
            }
        }
    }
}


