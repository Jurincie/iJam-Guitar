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
        return Text("\(appStates.first!.capoPosition)")
            .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .callout)
            .fontWeight(.semibold)
            .padding()
            .background(Color.clear)
            .foregroundColor(Color.white)
            .cornerRadius(4.0)
            .shadow(color: .white , radius: 2.0)
    }
}
    
    
//    @Binding var capoPosition: Int
//    let frets = Range(-2...5)
//    let kLabelWidth = 40.0
//
//    var body: some View {
//        VStack {
//            Menu {
//               Picker("Capo Position",
//                      selection: $capoPosition) {
//                   ForEach(frets, id: \.self) {
//                       Text(String($0))
//                   }
//               }
//               .pickerStyle(.automatic)
//           } label: {
//               getCapoLabel()
//           }
//       }
//    }
//    
//    func getCapoLabel() -> some View {
//        return Text("\(capoPosition)")
//            .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .callout)
//            .fontWeight(.semibold)
//            .padding()
//            .background(Color.clear)
//            .foregroundColor(Color.white)
//            .cornerRadius(4.0)
//            .shadow(color: .white , 
//                    radius: 2.0)
//    }
//}
