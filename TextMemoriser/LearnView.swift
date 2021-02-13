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
            if let currentReference = vm.currentReference {
                Content(passageText: currentReference.text, passageLocation: currentReference.location.display, next: nextPassage)
                    .navigationBarTitle("Learn the Verse")
            } else {
                Text("No references in learning set")
            }
        }
    }
    
    func nextPassage() {
        vm.currentReference = vm.passages.randomElement()
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
                Text(passageLocation)
                    .padding()
                
                Spacer()
                Button("Next", action: next)
                        .padding()
            }
        }
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
    }
}
