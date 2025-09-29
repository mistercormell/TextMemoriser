//
//  GuessLocationView2.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 29/09/2025.
//

import SwiftUI

enum GuessLocationQuestionType {
    case bookOnly
    case bookAndChapter
    case bookAndChapterAndVerse
}

struct GuessLocationView2: View {
    let passage: Passage
    let questionType: GuessLocationQuestionType
    
    @State var chapter = 1
    @State var verse = 1
    @State var selectedBook = Book.Genesis
    
    @Binding var question: Int
    
    @StateObject var questionFeedback = QuestionFeedback()
    
    var body: some View {
        VStack {
            Text("\(passage.text) (\(passage.copyright))")
                .padding()
            Form {
                Picker(selection: $selectedBook, label: Text("Book"), content: {
                    ForEach(Book.allCases, id: \.self) {
                        Text($0.displayName)
                    }
                })
                if questionType == .bookAndChapter || questionType == .bookAndChapterAndVerse {
                    Picker(selection: $chapter, label: Text("Chapter"), content: {
                        ForEach(0 ... 150, id: \.self) {
                            Text("\($0)")
                        }
                    })
                }
                if questionType == .bookAndChapterAndVerse {
                    Picker(selection: $verse, label: Text("Verse"), content: {
                        ForEach(0 ... 60, id: \.self) {
                            Text("\($0)")
                        }
                    })
                }
            }
            Button("Check", action: {
                var result = ""
                if questionType == .bookOnly {
                    result = passage.location.book == selectedBook ? "Correct" : "The correct book was: \(passage.location.book.displayName)"
                } else if questionType == .bookAndChapter {
                    result = passage.location.book == selectedBook && passage.location.chapter == chapter ? "Correct" : "The correct book and chapter was: \(passage.location.book.displayName) \(passage.location.chapter)"
                } else {
                    result = passage.location.book == selectedBook && passage.location.chapter == chapter && passage.location.verse == verse ? "Correct" : "The correct reference was: \(passage.location.display)"
                }
                questionFeedback.alertBody = result
                questionFeedback.isShowing = true
            })
                .padding()
        }
        .alert(isPresented: $questionFeedback.isShowing, content: {
            Alert(title: Text("\(questionFeedback.alertTitle)"), message: Text("\(questionFeedback.alertBody)"), dismissButton: .default(Text("OK")) { question += 1 } )})
    }
}

#Preview {
    GuessLocationView2(passage: Passage.example, questionType: .bookAndChapterAndVerse, question: .constant(1))
}
