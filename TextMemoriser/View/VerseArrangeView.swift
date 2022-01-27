//
//  VerseArrangeView.swift
//  TextMemoriser
//
//  Created by David Cormell on 04/01/2021.
//

import SwiftUI

struct VerseArrangeView: View {
    @State var wordsInVerse = [WordInVerse]()
    @State var wordsToPick = [WordInVerse]()
    @State var verseBeingBuilt = ""
    @StateObject var questionFeedback = QuestionFeedback()
    @EnvironmentObject var vm: StateController
    var wordGroupSize = 4
    
    var body: some View {
        Content(passage: vm.currentReference, check: checkAnswer, reset: reset, undo: undo, pickWord: pickWord, verseBeingBuilt: $verseBeingBuilt, wordsToPick: $wordsToPick)
            .onAppear(perform: {
                vm.loadReference()
                wordsToPick = vm.currentReference?.getVerseChunks(size: wordGroupSize) ?? []
            })
            .alert(isPresented: $questionFeedback.isShowing, content: {
                Alert(title: Text("\(questionFeedback.alertTitle)"), message: Text("\(questionFeedback.alertBody)\n\nYour score is: \(vm.score)"), dismissButton: .default(Text("OK")) {vm.nextQuestion()} )})
        
    }
    
    
    func checkAnswer() {
        if verseBeingBuilt == vm.currentReference?.text {
            questionFeedback.alertTitle = "Correct"
            vm.score += 1
            questionFeedback.alertBody = ""
        } else {
            questionFeedback.alertTitle = "The correct answer is"
            questionFeedback.alertBody = "\(vm.currentReference?.text ?? "")"
        }
        questionFeedback.isShowing = true
    }
    
    func reset() {
        verseBeingBuilt = ""
        wordsInVerse = []
        wordsToPick = vm.currentReference?.getVerseChunks(size: wordGroupSize) ?? []
    }
    
    func undo() {
        let wordToUndo = wordsInVerse.popLast()
        
        verseBeingBuilt = wordsInVerse.map { word in
            word.word
        }.joined(separator: " ")
        
        if let word = wordToUndo {
            wordsToPick.append(word)
        }
    }
        
    
    func pickWord(word: WordInVerse) {
        wordsInVerse.append(word)
        verseBeingBuilt = wordsInVerse.map { word in
            word.word
        }.joined(separator: " ")

        wordsToPick.removeAll {
            $0.id == word.id
        }
    }
    
}

extension VerseArrangeView {
    struct Content: View {
        let passage: Passage?
        let check: () -> Void
        let reset: () -> Void
        let undo: () -> Void
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
                        .padding()
                    Spacer()
                    Divider()
                    FlowLayoutView(mode: .vstack, binding: .constant(5), items: wordsToPick, viewMapping: { word in
                        Button(action: { pickWord(word) }) {
                            Text(word.word)
                                .padding(5)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    })
                    Divider()
                    HStack {
                        Button("Check", action: check)
                            .padding()
                        Button("Undo", action: undo)
                            .padding()
                        Button("Reset", action: reset)
                            .padding()
                    }
                }
                .navigationBarTitle("\(passage?.displayLocationWithCopyright ?? "")")
            }
        }
        
        
    }
}

struct VerseArrangeView_Previews: PreviewProvider {
    static var previews: some View {
        VerseArrangeView.Content(passage: Passage.example, check: {}, reset: {}, undo: {}, pickWord: {_ in }, verseBeingBuilt: .constant("In the Beginning,"), wordsToPick: .constant([WordInVerse(id: 1, word: "God"),WordInVerse(id: 2, word: "the"),WordInVerse(id: 3, word: "earth"),WordInVerse(id: 4, word: "created"),WordInVerse(id: 5, word: "heavens"), WordInVerse(id: 6, word: "and"),WordInVerse(id: 7, word: "the")]))
    }
}
