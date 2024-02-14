//
//  TuningPickerView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/18/22.
//

import SwiftData
import SwiftUI
import OSLog

struct TuningPickerView: View {
    @Query var appStates: [AppState]
    
    var body: some View {
        let appState = appStates.first!
        VStack {
            if let activeTuning = appState.activeTuning {
                Menu {
                    Picker("Chord Groups", selection: Bindable(appState).pickerTuningName) {
                        let tuningNames = appStates.first!.getTuningNames()
                        ForEach(tuningNames, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    .pickerStyle(.automatic)
                    .frame(maxWidth: .infinity)
                    .onChange(of: appState.pickerTuningName) { oldValue, newValue in
                        if let newTuning = appState.getTuning(name: newValue) {
                            appStates.first!.makeNewTuningActive(newTuning: newTuning)
                        }
                    }
                }
                label: {
                    Text(activeTuning.name ?? "")
                        .padding(10)
                        .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
                        .fontWeight(.semibold)
                        .background(Color.accentColor)
                        .foregroundColor(Color.white)
                        .shadow(color: .white , radius: 2.0)
                }
            }
        }
    }
}

extension View {
    func border(_ color: Color,
                width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width))
    }
}

//struct TuningPickerView: View {
//    @Query var appStates: [AppState]
//    
//    var body: some View {
//        let appState = appStates.first!
//        Text("")
//        VStack {
//            Menu {
//                Picker("Tunings", selection: Bindable(appState).activeTuningName) {
//                    ForEach(appState.getTuningNames(), id: \.self) {
//                        Text($0)
//                            .fixedSize()
//                    }
//                }
//                .pickerStyle(.automatic)
//                .frame(maxWidth: .infinity)
//           } label: {
//               Text("\(appState.activeTuningName)")
//                   .padding(10)
//                   .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .caption)
//                   .fontWeight(.semibold)
//                   .background(Color.accentColor)
//                   .foregroundColor(Color.white)
//                   .cornerRadius(10.0)
//                   .shadow(color: .white , radius: 2.0)
//                   .fixedSize()
//           }
//       }
//        .frame(alignment: .trailing)
//        .border(.white,
//                width: 2,
//                cornerRadius: 7)
//    }
//}


