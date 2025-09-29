//
//  ArrangeTheVerseView.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 29/09/2025.
//

import SwiftUI

struct ArrangeTheVerseView: View {
    @State var wordsInVerse = [WordInVerse]()
    @State var wordsToPick = [WordInVerse]()
    @State var verseBeingBuilt = ""
    @StateObject var questionFeedback = QuestionFeedback()
    @Binding var question: Int
    let chunks: Int?
    
    let passage: Passage
    
    var body: some View {
        Content(passage: passage, check: checkAnswer, reset: reset, undo: undo, pickWord: pickWord, verseBeingBuilt: $verseBeingBuilt, wordsToPick: $wordsToPick)
            .onAppear(perform: updateWordsToPick)
            .alert(isPresented: $questionFeedback.isShowing, content: {
                Alert(title: Text("\(questionFeedback.alertTitle)"), message: Text("\(questionFeedback.alertBody)"), dismissButton: .default(Text("OK")) { question += 1
                    updateWordsToPick()
                } )})
        
    }
    
    func updateWordsToPick() {
        wordsToPick = passage.getVerseChunks(numberOfChunks: chunks)
    }
    
    
    func checkAnswer() {
        if verseBeingBuilt == passage.text {
            questionFeedback.alertTitle = "Correct"
            questionFeedback.alertBody = ""
        } else {
            questionFeedback.alertTitle = "The correct answer is"
            questionFeedback.alertBody = "\(passage.text)"
        }
        questionFeedback.isShowing = true
    }
    
    func reset() {
        verseBeingBuilt = ""
        wordsInVerse = []
        wordsToPick = passage.getVerseChunks(numberOfChunks: chunks)
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

extension ArrangeTheVerseView {
    struct Content: View {
        let passage: Passage
        let check: () -> Void
        let reset: () -> Void
        let undo: () -> Void
        let pickWord: (WordInVerse) -> Void
        
        @Binding var verseBeingBuilt: String
        @Binding var wordsToPick: [WordInVerse]
        
        var body: some View {
            NavigationView {
                VStack {
                    Text(verseBeingBuilt)
                        .padding()
                    Spacer()
                    Divider()
                    FlowLayoutView(mode: .vstack, binding: .constant(8), items: wordsToPick, viewMapping: { word in
                        Button(action: { pickWord(word) }) {
                            Text(word.word)
                                .padding(5)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    })
                    .padding(.vertical, 8)
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
                .navigationBarTitle("\(passage.displayLocationWithCopyright)")
            }
        }
        
        
    }
}

#Preview {
    ArrangeTheVerseView(question: .constant(1), chunks: 4, passage: Passage.example)
}
