//
//  StringView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/5/22.
//

import Foundation
import SwiftData
import SwiftUI
import OSLog

// StringView has 2 layers:
//  bottom layer: appropriate string image
//  top layer:  VStack() of 6 possibly-RedBall images evenly spaced over top half of the stringsView

struct StringView: View {
    @Query var appStates: [AppState]
    let notes = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"]
    let height: CGFloat
    var stringImageName: String = ""
    let stringNumber: Int
    
    init(height: CGFloat,
         stringNumber: Int) {
        self.height = height
        self.stringNumber = stringNumber
        self.stringImageName = "String"
        stringImageName.append("\(stringNumber)")
    }
        
    var body: some View {
        let appState = appStates.first!
        let openNotesString = (appState.activeTuning?.stringNoteNames)
        if let openNotes: [String] = openNotesString?.components(separatedBy: ["-"]) {
            let fretBoxes: [FretBox] = getFretBoxArray(minFret: appState.minimumFret,
                                                       openStringNote: openNotes[6 - stringNumber])
            /*
             1x6 grid of Buttons with noteName in text on top of the possible image
             zero or one of the buttons may show the redBall image indicating string
             if fretted there
             */
            VStack(spacing:0) {
                ForEach(0...5, id: \.self) { index in
                    FretBoxView(fretBox: fretBoxes[index],
                                stringNumber:stringNumber)
                    .frame(width: height / 10, height: height / 12)
                }
                
                Spacer()
            }
            .background(Image(stringImageName)
                .resizable()
                .frame(width:20, height:height, alignment:.topLeading)
                .opacity(appState.currentFretIndexMap[6 - stringNumber] == -1 ? 0.3 : 1.0))
        }
        Spacer()
    }
    
    struct FretBoxView: View {
        let fretBox: FretBox
        let stringNumber: Int
        @Query var appStates: [AppState]
        var fretIsFromChord = false

        var body: some View {
            VStack {
                ZStack() {
                    // background
                    Button(action:{
                        let currentFret = appStates.first?.currentFretIndexMap[6 - stringNumber]
                        
                        if currentFret == 0 && fretBox.id == 0 {
                            // if nut tapped when string open => make string muted
                            appStates.first?.currentFretIndexMap[6 - stringNumber] = -1
                        } else if currentFret == fretBox.id {
                            // tapped existing fret => make string open
                            appStates.first?.currentFretIndexMap[6 - stringNumber] = 0
                        } else {
                            // tapped different fret
                            appStates.first?.currentFretIndexMap[6 - stringNumber] = fretBox.id
                        }
                    }){
                        if(self.fretBox.id == 0)
                        {
                            // show a white circle on zeroFret with black text
                            CircleView(color: Color.teal, lineWidth: 1.0)
                        } else if appStates.first?.currentFretIndexMap[6 - stringNumber] == fretBox.id {
                            // red ball on freted fretBox
                            // yellow ball if not in the chord - meaning user tapped on different fret
                            CircleView(color: fretIsFromChord ? Color.red : Color.yellow, lineWidth: 1.0)
                        } else {
                            CircleView()
                        }
                    }
                    // foreground
                    // show fretZero note names AND a (possibly) fretted fretBox
                    if self.fretBox.id == 0 {
                        Text(self.fretBox.title)
                            .foregroundColor(Color.white)
                            .font(.title3)
                            .fixedSize()
                    } else {
                        let text = self.fretBox.id == appStates.first?.currentFretIndexMap[6 - stringNumber] ? self.fretBox.title : ""
                        Text(text)
                            .foregroundColor(Color.black)
                            .font(.title3)
                            .fixedSize()
                    }
                }
            }
        }
    }
    
    func fretIsFromChord(fretNumber: Int) -> Bool {
        guard stringNumber < 6 && stringNumber >= 0 else { return true }
        
        let chordFretNumber = fretNumber
        let currentFretNumber = appStates.first?.currentFretIndexMap[6 - stringNumber]
        
        return currentFretNumber == chordFretNumber
    }
    
    struct FretBox: Identifiable  {
        let id: Int
        let title: String
    }
}

struct CircleView: View {
    let color: Color
    let lineWidth: CGFloat
    
    init(color: Color = Color.clear, lineWidth: CGFloat = 0.0) {
        self.color = color
        self.lineWidth = lineWidth
    }
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(color)
            Circle()
                .strokeBorder(.black, lineWidth: lineWidth)
        }
    }
}

extension StringView {
    func getFretBoxArray(minFret: Int, openStringNote: String) -> [FretBox] {
        let appState = appStates.first!
        var fretBoxArray:[FretBox] = []
        let index = appState.currentFretIndexMap[6 - stringNumber]
        fretBoxArray.append(FretBox(id: 0,
                                    title: index == -1 ?
                                    "X" : getFretNoteTitle(openNote: openStringNote,
                                                           offset: 0)))
        for index in Range(0...4) {
            let title = getFretNoteTitle(openNote: openStringNote,
                                         offset: index + minFret)
            fretBoxArray.append(FretBox(id: minFret + index,
                                        title: title))
        }
        return fretBoxArray
    }
    
    func getFretNoteTitle(openNote:String, offset:Int) -> String {
        let appState = appStates.first!
        if let index = self.notes.firstIndex(of: openNote) {
            var finalIndex = index + offset + appState.capoPosition
            if finalIndex < 0 {
                finalIndex += 12
            }
            return self.notes[finalIndex % 12]
        }
        return "C"
    }
}


