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
        .alert(isPresented: $vm.showingScore, content: {
                Alert(title: Text("\(vm.alertTitle)"), message: Text("Your score is: \(vm.score)"), dismissButton: .default(Text("OK")) {vm.nextQuestion()} )})
        
    }
    
    func loadReference() {
        vm.loadReference()
    }
    
    func checkAnswer() {
        if verseBeingBuilt == vm.currentReference?.text {
            vm.alertTitle = "Correct"
            vm.score += 1
        } else {
            vm.alertTitle = "Wrong!"
        }
        vm.showingScore = true
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
            NavigationView {
                VStack {
                    Text(verseBeingBuilt)
                    Spacer()
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
                    Divider()
                    HStack {
                        Button("Check", action: check)
                            .padding()
                        Button("Reset", action: reset)
                            .padding()
                    }
                }
                .navigationBarTitle("\(passage?.location.display ?? "")")
            }
        }
        
        
    }
}

struct VerseArrangeView_Previews: PreviewProvider {
    static var previews: some View {
        VerseArrangeView.Content(passage: Passage(location: VerseLocation(book: "Genesis", chapter: 1, verse: 1), text: "In the Beginning, God created the heavens and the earth"), check: {}, reset: {}, pickWord: {_ in }, verseBeingBuilt: .constant("In the Beginning,"), wordsToPick: .constant([WordInVerse(id: 1, word: "God"),WordInVerse(id: 2, word: "the"),WordInVerse(id: 3, word: "earth"),WordInVerse(id: 4, word: "created"),WordInVerse(id: 5, word: "heavens"), WordInVerse(id: 6, word: "and"),WordInVerse(id: 7, word: "the")]))
    }
}
