//
//  GuessLocationViewModel.swift
//  TextMemoriser
//
//  Created by David Cormell on 07/01/2021.
//

import Foundation

class GuessLocationViewModel: ObservableObject {
    var references: [Reference] = []
    let books = ["Genesis", "Exodus", "Leviticus", "John", "Colossians", "1 Timothy", "2 Timothy"]
    let sampleVerses = [(book: "John", chapter: 3, verse: 16),
                        (book: "Colossians", chapter: 3, verse: 16),
                        (book: "2Timothy", chapter: 1, verse: 7),
                        (book: "Genesis", chapter: 1, verse: 1),
                        (book: "Romans", chapter: 8, verse: 20),
                        (book: "Revelation", chapter: 3, verse: 20)
                        ]
    
    let adaptor = EsvBibleAdaptor()

    @Published var chapter = 1
    @Published var verse = 1
    @Published var selectedBook = 0
    @Published var currentReference: Reference?
    @Published var alertTitle = ""
    @Published var showingScore = false
    @Published var score = 0
    
    func fetchReferences() {
        for (index, verse) in sampleVerses.enumerated() {
            adaptor.fetchVerseWithReference(book: verse.book, chapter: verse.chapter, verse: verse.verse, completion: { reference in
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
    
}
