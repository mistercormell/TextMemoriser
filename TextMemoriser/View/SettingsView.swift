//
//  SettingsView.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 11/03/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var stateController: StateController
    
    var body: some View {
        Form {
            Picker(selection: $stateController.translation, label: Text("Translation:"), content: {
                ForEach(Translation.allCases, id: \.self) { translation in
                    Text(translation.details.description)
                        .tag(translation)
                }
            })
        }
    }
}

#Preview {
    SettingsView().environmentObject(StateController())
}
