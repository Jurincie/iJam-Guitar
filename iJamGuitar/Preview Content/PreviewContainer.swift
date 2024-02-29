//
//  PreviewContainer.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 2/29/24.
//

import SwiftData
import SwiftUI

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: AppState.self,
                                           configurations: .init(isStoredInMemoryOnly: true))
 
        // build appState HERE
        let appState = AppState()
        container.mainContext.insert(appState)
        
        /*
         var openNoteIndices: String
         var stringNoteNames: String
         var chordsDictionary = [String:String]()
         var activeChordGroup:
         
         */
        
        
        
//        let standardTuning = Tuning()
//        do {
//            try setupTuning(tuning: standardTuning,
//                            tuningName: "Standard",
//                            openIndices: "4-9-14-19-23-28",
//                            noteNames: "E-A-D-G-B-E",
//                            chordLibraryFileName: "StandardTuning_ChordLibrary",
//                            chordGroupsFileName: "StandardTuningChordGroups")
//        } catch {
//            throw PlistError.unknownError
//        }
                                    
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
