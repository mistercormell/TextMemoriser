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
    @State var normalizedText = ""
    @State var verseBeingBuilt = ""
    @StateObject var questionFeedback = QuestionFeedback()
    @Binding var question: Int
    @Binding var confettiTrigger: Int
    let chunks: Int?
    
    @Environment(MemorisationProgress.self) var memorisationProgress: MemorisationProgress
    
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
        let verseChunks = passage.getVerseChunks(numberOfChunks: chunks)
        wordsToPick = verseChunks.0
        normalizedText = verseChunks.1
        
    }
    
    
    func checkAnswer() {
        if verseBeingBuilt == normalizedText {
            memorisationProgress.correctAnswer(verse: passage.location)
            confettiTrigger += 1
            question += 1
        } else {
            questionFeedback.alertTitle = "Incorrect"
            questionFeedback.alertBody = "The correct verse is: \(passage.text)"
            memorisationProgress.incorrectAnswer(verse: passage.location)
            questionFeedback.isShowing = true
        }
        
    }
    
    func reset() {
        verseBeingBuilt = ""
        wordsInVerse = []
        let verseChunks = passage.getVerseChunks(numberOfChunks: chunks)
        wordsToPick = verseChunks.0
        normalizedText = verseChunks.1
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
                VStack {
                    Text("\(passage.displayLocationWithCopyright)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(verseBeingBuilt)
                        .padding()
                    Spacer()
                    Divider()
                    FlowLayoutView(mode: .vstack, binding: .constant(8), items: wordsToPick, viewMapping: { word in
                        Button(action: { pickWord(word) }) {
                            Text(word.word)
                                .padding(5)
                                .background(BrandStyle.primary)
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
        }
        
        
    }
}

#Preview {
    ArrangeTheVerseView(question: .constant(1), confettiTrigger: .constant(1), chunks: 4, passage: Passage.example)
        .environment(MemorisationProgress())
}
