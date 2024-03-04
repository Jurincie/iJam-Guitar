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
        let openNotesString = (appStates.first!.activeTuning?.stringNoteNames)
        if let openNotes: [String] = openNotesString?.components(separatedBy: ["-"]) {
            let fretBoxes: [FretBox] = getFretBoxArray(minFret: appStates.first!.minimumFret,
                                                       openStringNote: openNotes[6 - stringNumber])
            /*
             1x6 grid of Buttons with noteName in text on top of the possible image
             zero or one of the buttons may show the redBall image indicating string
             if fretted there
             */
            VStack(spacing:0) {
                FretBoxView(fretBox: fretBoxes[0],
                            stringNumber:stringNumber)
                .frame(width: height / 10, height: height / 12, alignment: .top)
                FretBoxView(fretBox: fretBoxes[1],
                            stringNumber:stringNumber)
                .frame(width: height / 10, height: height / 12, alignment: .top)
                FretBoxView(fretBox: fretBoxes[2],
                            stringNumber:stringNumber)
                .frame(width: height / 10, height: height / 12, alignment: .top)
                FretBoxView(fretBox: fretBoxes[3],
                            stringNumber:stringNumber)
                .frame(width: height / 10, height: height / 12, alignment: .top)
                FretBoxView(fretBox: fretBoxes[4],
                            stringNumber:stringNumber)
                .frame(width: height / 10, height: height / 12, alignment: .top)
                FretBoxView(fretBox: fretBoxes[5],
                            stringNumber:stringNumber)
                .frame(width: height / 10, height: height / 12, alignment: .top)
                
                Spacer()
            }
            .background(Image(stringImageName)
                .resizable()
                .frame(width:20, height:height, alignment:.topLeading)
                .opacity(appStates.first!.currentFretPositions[6 - stringNumber] == -1 ? 0.3 : 1.0))
        }
    }
 
    struct FretBox: Identifiable  {
        let id: Int
        let title: String
    }
    
    struct FretBoxView: View {
        let fretBox: FretBox
        let stringNumber: Int
        
        init(fretBox: FretBox, stringNumber: Int) {
            self.fretBox = fretBox
            self.stringNumber = stringNumber
        }
        
        var body: some View {
            ZStack() {
                // background
                BackgroundView(fretNumber: fretBox.id, stringNumber: stringNumber)
                ForegroundView(fretNumber: fretBox.id,
                               title: fretBox.title,
                               stringNumber: stringNumber)
            }
        }
    }
}

struct ForegroundView: View {
    @Query var appStates: [AppState]
    let fretNumber: Int
    let title: String
    let stringNumber: Int
    
    var body: some View {
        let appState = appStates.first!
        // foreground
        // show fretZero note names AND a (possibly) fretted fretBox
        if fretNumber == 0 {
            Text(title)
                .foregroundColor(Color.white)
                .font(.title3)
                .fixedSize()
        } else {
            let text = fretNumber == appState.currentFretPositions[6 - stringNumber] ? title : ""
            Text(text)
                .font(.title3)
                .fixedSize()
        }
    }
}

struct BackgroundView: View {
    @Query var appStates: [AppState]
    var fretNumber: Int
    let stringNumber: Int
    
    var body: some View {
        let appState = appStates.first!
        Button(action: {
            let index = 6 - stringNumber
            var correctedFret = fretNumber
            
            let currentFret = appState.currentFretPositions[index]
            if  currentFret == 0 && fretNumber == 0 {
                correctedFret = -1
            } else if appState.currentFretPositions[index] == fretNumber {
                correctedFret = 0
            }
            
            // get the current appState.fretIndicesString
            // replace the nth character
            appState.currentFretPositions[index] = correctedFret
        }){
            if(fretNumber == 0) {
                // show a gray circle on zeroFret with black text
                CircleView(color: Color.teal)
            } else if fretNumber == appState.currentFretPositions[6 - stringNumber] {
                CircleView(color: appState.fretBelongsInChord(stringNumber: stringNumber, newFretNumber: fretNumber) ? Color.red : Color.yellow, lineWidth: 1.0)
            } else {
                CircleView(color: Color.clear, lineWidth: 0)
            }
        }
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
                .strokeBorder(.white, lineWidth: lineWidth)
        }
    }
}

extension StringView {
    func getFretBoxArray(minFret: Int, openStringNote: String) -> [FretBox] {
        let appState = appStates.first!
        var fretBoxArray:[FretBox] = []
        let index = appState.currentFretPositions[6 - stringNumber]
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

func getCharForFretNumber(_ number: Int) -> String {
    switch(number) {
    case 0...9: return String(number)
    case 10: return "A"
    case 11: return "B"
    case 12: return "C"
    case 13: return "D"
    case 14: return "E"
    default: return "x"
    }
}

