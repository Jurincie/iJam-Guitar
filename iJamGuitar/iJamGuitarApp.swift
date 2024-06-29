//
//  iJamGuitarApp.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/4/23.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct iJamGuitarApp: App {
    var shouldCreateUserDefaults: Bool = !UserDefaults.standard.bool(forKey: "DataExists")
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(AppStateContainer.create(shouldCreateUserDefaults))
    }
}

