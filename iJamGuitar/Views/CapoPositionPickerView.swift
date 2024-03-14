//
//  CapoPositionPickerView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 5/17/22.
//

import OSLog
import SwiftData
import SwiftUI

struct CapoPositionPickerView: View {
    @Query var appStates: [AppState]
    let frets = Range(-2...5)
    let kLabelWidth = 40.0

    var body: some View {
        VStack {
            Menu {
                Picker("Capo Position", selection: Bindable(appStates.first!).capoPosition) {
                   ForEach(frets, id: \.self) {
                       Text(String($0))
                   }
               }
               .pickerStyle(.automatic)
           } label: {
               getCapoLabel()
           }
       }
    }
        
    func getCapoLabel() -> some View {
        let isIpad = UserDefaults.standard.bool(forKey: "IsIpad")
        return Text("\(appStates.first!.capoPosition)")
            .font(isIpad ? .title2 : .callout)
            .font(isIpad ? .title2 : .callout)
            .fontWeight(.semibold)
            .padding()
            .background(Color.clear)
            .foregroundColor(Color.primary)
            .cornerRadius(4.0)
            .shadow(color: .white , radius: 2.0)
    }
}
