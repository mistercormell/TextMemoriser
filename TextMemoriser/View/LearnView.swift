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
        Group {
            if let currentReference = vm.currentReference {
                Content(passageText: currentReference.text, passageLocation: currentReference.location.display, passageLocationWithCopyright: currentReference.displayLocationWithCopyright, passage: currentReference, passageTextOpacity: 1.0)
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
        let passage: Passage
        @State var passageTextOpacity = 1.0
        @State private var speechSynthesizer = AVSpeechSynthesizer()
        @State private var isMemorising = false
        
        var body: some View {
            VStack {
                Button(action: {
                    let utterance = AVSpeechUtterance(string: "\(passageText):\(passageLocation)")
                    utterance.rate = 0.4
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                    
                    speechSynthesizer.speak(utterance)
                }, label: {
                    Image(systemName: "speaker.2")
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
                Button("Memorise this verse") {
                    isMemorising = true
                }
                .buttonStyle(.borderedProminent)
                .padding()
                Spacer()
            }
            .fullScreenCover(isPresented: $isMemorising) {
                MemoriseView(passage: passage, isMemorising: $isMemorising)
            }
        }

    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LearnView.Content(passageText: Passage.example.text, passageLocation: Passage.example.location.display, passageLocationWithCopyright: Passage.example.displayLocationWithCopyright, passage: Passage.example, passageTextOpacity: 1.0)
        }
    }
}
