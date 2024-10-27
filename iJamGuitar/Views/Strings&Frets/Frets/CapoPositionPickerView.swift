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
    
    var body: some View {
        VStack {
            Menu {
                Picker("Capo Position", selection: Bindable(appStates.first!).capoPosition) {
                    ForEach(Range(-2...5), id: \.self) {
                        Text(String($0))
                    }
                }
                .padding(.bottom)
                .pickerStyle(.menu)
            } label: {
                getCapoLabel()
            }
        }
    }
    
    func getCapoLabel() -> some View {
        return Text("\(appStates.first!.capoPosition)")
            .font(.headline)
            .fontWeight(.semibold)
            .padding()
            .foregroundStyle(Color.white)
            .cornerRadius(4.0)
            .shadow(color: .white , radius: 2.0)
    }
}
