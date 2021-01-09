//
//  TextMemoriserApp.swift
//  TextMemoriser
//
//  Created by David Cormell on 03/01/2021.
//

import SwiftUI

@main
struct TextMemoriserApp: App {
    var body: some Scene {
        WindowGroup {
            PracticeView()
                .environmentObject(StateController())
        }
    }
}
