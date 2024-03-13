//
//  LearnView.swift
//  TextMemoriser
//
//  Created by David Cormell on 30/01/2021.
//

import SwiftUI
import AVFoundation

struct LearnView: View {
    @EnvironmentObject var vm: StateController
    var selectedVerse: VerseLocation
    
    var body: some View {
        NavigationView {
            if let currentReference = vm.currentReference {
                Content(passageText: currentReference.text, passageLocation: currentReference.location.display, passageLocationWithCopyright: currentReference.displayLocationWithCopyright, passageTextOpacity: 1.0)
            } else {
                ProgressView("Loading verses...")
            }
        }
        .onAppear(perform: { vm.updateCurrentReference(location: selectedVerse) })
    }
}

extension LearnView {
    struct Content: View {
        let passageText: String
        let passageLocation: String
        let passageLocationWithCopyright: String
        @State var passageTextOpacity = 1.0
        @State private var speechSynthesizer = AVSpeechSynthesizer()
        
        var body: some View {
            VStack {
                Button(action: {
                    let utterance = AVSpeechUtterance(string: "\(passageText):\(passageLocation)")
                    utterance.rate = 0.4
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                    
                    speechSynthesizer.speak(utterance)
                }, label: {
                    Image(systemName: "speaker")
                        .font(.largeTitle)
                        .padding()
                })
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
                    Text(passageLocationWithCopyright)
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
            LearnView.Content(passageText: Passage.example.text, passageLocation: Passage.example.location.display, passageLocationWithCopyright: Passage.example.displayLocationWithCopyright, passageTextOpacity: 1.0)
        }
    }
}
