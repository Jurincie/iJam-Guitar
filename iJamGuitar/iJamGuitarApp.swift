//
//  iJamGuitarApp.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/4/23.
//

import SwiftUI

@main
struct iJamGuitarApp: App {
    @State var model = iJamViewModel.shared

    var body: some Scene {
        WindowGroup {
            ContentView(dataModel: $model)
        }
    }
}

