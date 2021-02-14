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
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func saveUserSettings() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(learningSet) {
            if let json = String(data: encoded, encoding: .utf8) {
                //do file handling to save this json
                let url = self.getDocumentsDirectory().appendingPathComponent("settings.json")
                do {
                    try json.write(to: url, atomically: true, encoding: .utf8)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
        
    func restoreUserSettings() {
        let url = self.getDocumentsDirectory().appendingPathComponent("settings.json")
        if let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode([VerseLocation].self, from: data) {
                learningSet = loaded
            } else {
                print("Failed to decode")
                //fatalError("Failed to decode \(url) from documents.")
            }
            
            
        }
    }
}
