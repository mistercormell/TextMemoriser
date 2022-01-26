//
//  LearnView.swift
//  TextMemoriser
//
//  Created by David Cormell on 30/01/2021.
//

import SwiftUI

struct LearnView: View {
    @EnvironmentObject var vm: StateController
    var selectedVerse: VerseLocation
    
    var body: some View {
        NavigationView {
            if vm.learningSet.count != 0 {
                if let currentReference = vm.currentReference {
                    Content(passageText: currentReference.text, passageLocation: currentReference.displayLocationWithCopyright, passageTextOpacity: 1.0)
                } else {
                    ProgressView("Loading verses...")
                }
            } else {
                Text("Please add verses to your learning set to start learning!")
            }
        }
        .onAppear(perform: { vm.updateCurrentReference(location: selectedVerse) })
    }
}

extension LearnView {
    struct Content: View {
        let passageText: String
        let passageLocation: String
        @State var passageTextOpacity = 1.0
        
        var body: some View {
            VStack {
                Text(passageText)
                    .padding()
                    .opacity(passageTextOpacity)
                    .border(.gray)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            passageTextOpacity == 1.0 ? (passageTextOpacity = 0.0) : (passageTextOpacity = 1.0)
                        }
                    }
                HStack {
                    Spacer()
                    Text(passageLocation)
                        .bold()
                        .padding()
                }
                Spacer()

            }
        }
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LearnView.Content(passageText: Passage.example.text, passageLocation: Passage.example.displayLocationWithCopyright, passageTextOpacity: 1.0)
        }
    }
}
