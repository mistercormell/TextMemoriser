//
//  GuessLocationViewModel.swift
//  TextMemoriser
//
//  Created by David Cormell on 07/01/2021.
//

import Foundation

class StateController: ObservableObject {
    //all possible views
    let learningSet = [VerseLocation(book: "John", chapter: 3, verse: 16),
                        VerseLocation(book: "Colossians", chapter: 3, verse: 16),
                        VerseLocation(book: "2Timothy", chapter: 1, verse: 7),
                        VerseLocation(book: "Genesis", chapter: 1, verse: 1),
                        VerseLocation(book: "Romans", chapter: 8, verse: 20),
                        VerseLocation(book: "Revelation", chapter: 3, verse: 20)
                        ]
    
    let adaptor = EsvBibleAdaptor()
    @Published var passages: [Passage] = []

    //guessLocationView
    @Published var chapter = 1
    @Published var verse = 1
    @Published var selectedBook = Book.Genesis
    @Published var alertTitle = ""
    @Published var showingScore = false
    @Published var score = 0
    
    //arrangeVerseView
    @Published var wordsToPick = [WordInVerse]()
    
    //practiceView
    @Published var currentReference: Passage?
    @Published var questionType: Question = .guessLocation
    
    func fetchReferences() {
        for (index, verse) in learningSet.enumerated() {
            adaptor.fetchVerseWithReference(location: verse, completion: { reference in
                DispatchQueue.main.async {
                    self.passages.append(reference)
                    if index == 0 {
                        self.currentReference = self.passages.randomElement()
                        self.wordsToPick = self.currentReference?.wordsInVerse ?? []
                    }
                }
            })
        }
    }
    
    func loadReference() {
        if passages.count == 0 {
            fetchReferences()
        } else {
            currentReference = passages.randomElement()
            wordsToPick = currentReference?.wordsInVerse ?? []
        }
    }
    
    func nextQuestion() {
        if questionType == .guessLocation {
            questionType = .arrangeVerse
        } else {
            questionType = .guessLocation
        }
        loadReference()
    }
    

    
}
