//
//  BlueRoundedButton.swift
//  TextMemoriser
//
//  Created by David Cormell on 28/01/2022.
//

import Foundation
import SwiftUI

struct BlueRoundedButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(Color.white)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
    }
}
