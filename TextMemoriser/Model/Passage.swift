//
//  Passage.swift
//  TextMemoriser
//
//  Created by David Cormell on 09/01/2021.
//

import Foundation

struct Passage: Equatable {
    let location: VerseLocation
    let text: String
    let copyright: String
    
    var displayLocationWithCopyright: String {
        "\(location.display) (\(copyright))"
    }
    
    var wordsInVerse: [WordInVerse] {
        let words = text.components(separatedBy: " ").shuffled()
        var wordsInVerses = [WordInVerse]()
        
        for (index, word) in words.enumerated() {
            wordsInVerses.append(WordInVerse(id: index, word: word))
        }
        
        return wordsInVerses
    }
    
    func getTextWithMissingWord() -> (blankedText: String, missingWord: String) {
        let words = text.split(whereSeparator: \.isLetter.negation)
        let missingWord = String(words.randomElement() ?? "")
        let maskedMissingWord = String(repeating: "_", count: missingWord.count)
        let blankedText = text.replacingOccurrences(of: missingWord, with: maskedMissingWord)
        
        return (blankedText, missingWord)
    }
    
    static func == (lhs: Passage, rhs: Passage) -> Bool {
        return lhs.text == rhs.text ? true : false
    }
    
    //#if DEBUG
    static let example = Passage(location: VerseLocation(book: Book.Colossians, chapter: 3, verse: 16), text: "Let the word of Christ dwell in you richly, teaching and admonishing one another in all wisdom, singing psalms and hymns and spiritual songs, with thankfulness in your hearts to God.", copyright: "ESV")
    //#endif
}
