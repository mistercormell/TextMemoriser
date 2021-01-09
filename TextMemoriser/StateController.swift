//
//  StateController.swift
//  TextMemoriser
//
//  Created by David Cormell on 09/01/2021.
//

import Foundation

class StateController: ObservableObject {
    @Published var passageCache: [Passage] = []
    @Published var learningSet: [VerseLocation] = [VerseLocation(book: "John", chapter: 3, verse: 16),
                                                   VerseLocation(book: "Colossians", chapter: 3, verse: 16),
                                                   VerseLocation(book: "2Timothy", chapter: 1, verse: 7),
                                                   VerseLocation(book: "Genesis", chapter: 1, verse: 1),
                                                   VerseLocation(book: "Romans", chapter: 8, verse: 20),
                                                   VerseLocation(book: "Revelation", chapter: 3, verse: 20)]
    let adaptor = EsvBibleAdaptor()
    
    func fetchPassage() {
        
            adaptor.fetchVerseWithReference(location: learningSet[0], completion: { reference in
                DispatchQueue.main.async {
                    self.passageCache.append(reference)
                }
            })
    }
}
