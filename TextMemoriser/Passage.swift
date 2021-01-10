//
//  Passage.swift
//  TextMemoriser
//
//  Created by David Cormell on 09/01/2021.
//

import Foundation

struct Passage {
    let location: VerseLocation
    let text: String
    
    var wordsInVerse: [WordInVerse] {
        let words = text.components(separatedBy: " ").shuffled()
        var wordsInVerses = [WordInVerse]()
        
        for (index, word) in words.enumerated() {
            wordsInVerses.append(WordInVerse(id: index, word: word))
        }
        
        return wordsInVerses
    }
}
