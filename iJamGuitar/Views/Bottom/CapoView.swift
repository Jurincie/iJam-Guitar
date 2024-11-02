//
//  CapoView.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 11/1/24.
//

import SwiftData
import SwiftUI



struct CapoView: View {
    @Query var appStates: [AppState]
    
    var capoPositions = Array(-2...5)

    var body: some View {
        if let appState = appStates.first {
            HStack {
                ViewThatFits {
                    Text("Capo Position")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .padding()
                    Text("Capo")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .padding()
                }
                .minimumScaleFactor(0.5)
                
                Menu {
                    Picker("Capo Position", selection: Bindable(appState).capoPosition) {
                        ForEach(capoPositions, id: \.self) { capoPosition in
                            Text("\(capoPosition)")
                                .font(.caption)
                        }
                    }
                    .pickerStyle(.automatic)
                } label: {
                    if let appState = appStates.first {
                        Text(String(appState.capoPosition))
                            .padding()
                            .font(.headline)
                            .fontWeight(.semibold)
                            .background(Color.accentColor)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.trailing)
            }
        }
    }
}

#Preview {
    CapoView()
}
