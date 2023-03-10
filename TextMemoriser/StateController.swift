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
    
    var progress: [VerseLocation:VerseMastery] = [:]
    let adaptor = EsvBibleAdaptor()
    
    @Published var passages: [Passage] = []
    @Published var currentReference: Passage?
    @Published var score = 0
    @Published var questionType: Question = .guessLocation

    func fetchReference(location: VerseLocation) {
        adaptor.fetchVerseWithReference(location: location, completion: { reference in
            DispatchQueue.main.async {
                self.passages.append(reference)
            }
        })
    }
    
    func fetchReferences() {
        for verse in learningSet {
            adaptor.fetchVerseWithReference(location: verse, completion: { reference in
                DispatchQueue.main.async {
                    self.passages.append(reference)
                }
            })
        }
    }
    
    func updateCurrentReference(location: VerseLocation) {
        self.currentReference = passages.first(where: {
            $0.location == location
        })
    }
    
    func constructQuestionSet(of questionTypes: [Question], count: Int) -> [(passage: Passage, type: Question)] {
        var questionSet: [(passage: Passage, type: Question)] = []
        
        if self.passages.isEmpty.negation {
            for _ in 1...count {
                let randomPassage = self.passages.randomElement()!
                let randomQuestion = questionTypes.randomElement()!
                questionSet.append((passage: randomPassage, type: randomQuestion))
            }
        }
        
        return questionSet
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
