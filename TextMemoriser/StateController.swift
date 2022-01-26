//
//  GuessLocationViewModel.swift
//  TextMemoriser
//
//  Created by David Cormell on 07/01/2021.
//

import Foundation

class StateController: ObservableObject {
    //all possible views
    @Published var learningSet: [VerseLocation] = [] {
        didSet {
            self.saveUserSettings()
        }
    }
    
    let adaptor = EsvBibleAdaptor()
    @Published var passages: [Passage] = []
    @Published var currentReference: Passage?

    //guessLocationView
    @Published var chapter = 1
    @Published var verse = 1
    @Published var selectedBook = Book.Genesis
    @Published var alertTitle = ""
    @Published var showingScore = false
    @Published var score = 0
    
    //arrangeVerseView
    @Published var wordsToPick = [WordInVerse]()
    
    //guessMissingWordView
    @Published var textWithMissingWord: (blankedText: String, missingWord: String) = ("","")
    
    //practiceView
    @Published var questionType: Question = .guessLocation
    
    func fetchReference(location: VerseLocation) {
        adaptor.fetchVerseWithReference(location: location, completion: { reference in
            DispatchQueue.main.async {
                self.passages.append(reference)
            }
        })
    }
    
    func fetchReferences() {
        for (index, verse) in learningSet.enumerated() {
            adaptor.fetchVerseWithReference(location: verse, completion: { reference in
                DispatchQueue.main.async {
                    self.passages.append(reference)
                    if index == 0 {
                        self.selectReference()
                        self.wordsToPick = self.currentReference?.wordsInVerse ?? []
                        self.textWithMissingWord = self.currentReference?.getTextWithMissingWord() ?? ("","")
                    }
                }
            })
        }
    }
    
    func selectReference() {
        var randomReference = self.passages.randomElement()
        
        if passages.count > 1 {
            while randomReference == self.currentReference {
                randomReference = self.passages.randomElement()
            }
        }
        
        self.currentReference = randomReference
    }
    
    func updateCurrentReference(location: VerseLocation) {
        self.currentReference = passages.first(where: {
            $0.location == location
        })
    }
    
    func loadReference() {
        if passages.count == 0 {
            fetchReferences()
        } else {
            selectReference()
            wordsToPick = currentReference?.wordsInVerse ?? []
        }
    }
    
    func nextQuestion() {
        if questionType == .guessLocation {
            questionType = .arrangeVerse
        } else if questionType == .arrangeVerse {
            questionType = .missingWord
        } else {
            questionType = .guessLocation
        }
    }
    
    func addVerseToLearningSet(_ verseToAdd: VerseLocation) {
        fetchReference(location: verseToAdd)
        learningSet.append(verseToAdd)
        currentReference = passages.randomElement()
    }
    
    func removeVerseFromLearningSet(atOffset indexSet: IndexSet) {
        let idsToDelete = indexSet.map { self.learningSet[$0].id }
        for id in idsToDelete {
            passages.removeAll(where: {$0.location.id == id })
        }
        
        learningSet.remove(atOffsets: indexSet)
    }
        
    func saveUserSettings() {
        FileManager.default.save(to: "settings.json", object: learningSet)
    }
        
    func restoreUserSettings() {
        if let loadedLearningSet: [VerseLocation] = FileManager.default.load(from: "settings.json") {
            learningSet = loadedLearningSet
        }
    }
}
