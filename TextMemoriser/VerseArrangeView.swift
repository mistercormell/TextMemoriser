//
//  VerseArrangeView.swift
//  TextMemoriser
//
//  Created by David Cormell on 04/01/2021.
//

import SwiftUI

struct VerseArrangeView: View {
    @State var wordsInVerse = [WordInVerse]()
    @State var verseBeingBuilt = ""
    @EnvironmentObject var vm: StateController
    
    var body: some View {
        Content(passage: vm.currentReference, check: checkAnswer, reset: reset, pickWord: pickWord, verseBeingBuilt: $verseBeingBuilt, wordsToPick: $vm.wordsToPick)
        .onAppear(perform: loadReference)
        
    }
    
    func loadReference() {
        vm.loadReference()
    }
    
    func checkAnswer() {
        if verseBeingBuilt == vm.currentReference?.text {
            print("Correct")
        } else {
            print("Incorrect")
        }
        vm.nextQuestion()
    }
    
    func reset() {
        verseBeingBuilt = ""
        vm.wordsToPick = vm.currentReference?.wordsInVerse ?? []
    }
    
    func pickWord(word: WordInVerse) {
        wordsInVerse.append(word)
        verseBeingBuilt = wordsInVerse.map { word in
            word.word
        }.joined(separator: " ")

        vm.wordsToPick.removeAll {
            $0.id == word.id
        }
    }
    
}

extension VerseArrangeView {
    struct Content: View {
        let passage: Passage?
        let check: () -> Void
        let reset: () -> Void
        let pickWord: (WordInVerse) -> Void
        
        let columns = [
            GridItem(.adaptive(minimum: 80))
        ]
        
        @Binding var verseBeingBuilt: String
        @Binding var wordsToPick: [WordInVerse]
        
        var body: some View {
            VStack {
                Text("\(passage?.location.display ?? "")")
                    .font(.largeTitle)
                Divider()
                Text(verseBeingBuilt)
                Spacer()
                Divider()
                HStack {
                    Button("Check", action: check)
                    Button("Reset", action: reset)
                }
                Divider()
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(wordsToPick, id: \.id) { word in
                        Button(action: { pickWord(word) }) {
                            Text(word.word)
                                .padding(5)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                }
            }
        }
        
        
    }
}

struct VerseArrangeView_Previews: PreviewProvider {
    static var previews: some View {
        VerseArrangeView()
    }
}
