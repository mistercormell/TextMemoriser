//
//  LearnView.swift
//  TextMemoriser
//
//  Created by David Cormell on 30/01/2021.
//

import SwiftUI

struct LearnView: View {
    @EnvironmentObject var vm: StateController
    
    var body: some View {
        NavigationView {
            if vm.learningSet.count != 0 {
                if let currentReference = vm.currentReference {
                    Content(passageText: currentReference.text, passageLocation: currentReference.displayLocationWithCopyright, next: vm.loadReference)
                        .navigationBarTitle("Learn the Verse")
                } else {
                    ProgressView("Loading verses...")
                }
            } else {
                Text("Please add verses to your learning set to start learning!")
            }
        }
        .onAppear(perform: vm.loadReference)
    }
}

extension LearnView {
    struct Content: View {
        let passageText: String
        let passageLocation: String
        let next: () -> Void
        
        var body: some View {
            VStack {
                Text(passageText)
                    .padding()
                HStack {
                    Spacer()
                    Text(passageLocation)
                        .padding()
                }
                
                Spacer()
                Button("Next", action: next)
                        .padding()
            }
        }
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LearnView.Content(passageText: Passage.example.text, passageLocation: Passage.example.displayLocationWithCopyright, next: {})
                .navigationTitle("Learn the Verse")
        }
    }
}
