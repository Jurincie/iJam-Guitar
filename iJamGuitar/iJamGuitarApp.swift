//
//  iJamGuitarApp.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/4/23.
//

import SwiftUI

@main
struct iJamGuitarApp: App {
    var shouldCreateUserDefaults: Bool = !UserDefaults.standard.bool(forKey: "DataExists")
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(AppStateContainer.create(shouldCreateUserDefaults))
    }
}

