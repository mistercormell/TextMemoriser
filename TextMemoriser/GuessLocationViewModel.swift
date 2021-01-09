//
//  GuessLocationViewModel.swift
//  TextMemoriser
//
//  Created by David Cormell on 07/01/2021.
//

import Foundation

class StateController: ObservableObject {
    var references: [Passage] = []
    let books = ["Genesis", "Exodus", "Leviticus", "John", "Colossians", "1 Timothy", "2 Timothy"]
    let sampleVerses = [VerseLocation(book: "John", chapter: 3, verse: 16),
                        VerseLocation(book: "Colossians", chapter: 3, verse: 16),
                        VerseLocation(book: "2Timothy", chapter: 1, verse: 7),
                        VerseLocation(book: "Genesis", chapter: 1, verse: 1),
                        VerseLocation(book: "Romans", chapter: 8, verse: 20),
                        VerseLocation(book: "Revelation", chapter: 3, verse: 20)
                        ]
    
    let adaptor = EsvBibleAdaptor()

    @Published var chapter = 1
    @Published var verse = 1
    @Published var selectedBook = Book.Genesis
    @Published var currentReference: Passage?
    @Published var alertTitle = ""
    @Published var showingScore = false
    @Published var score = 0
    @Published var questionType: Question = .guessLocation
    
    func fetchReferences() {
        for (index, verse) in sampleVerses.enumerated() {
            adaptor.fetchVerseWithReference(location: verse, completion: { reference in
                DispatchQueue.main.async {
                    self.references.append(reference)
                    if index == 0 {
                        self.currentReference = self.references.randomElement()
                    }
                }
            })
        }
    }
    
    func loadReference() {
        if references.count == 0 {
            fetchReferences()
        } else {
            currentReference = references.randomElement()
        }
    }
    
    func nextQuestion() {
        questionType = Question.allCases.randomElement()!
    }
    
}
