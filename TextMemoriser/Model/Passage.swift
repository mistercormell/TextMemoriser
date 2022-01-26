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
        return getVerseChunks(size: 1)
    }
    
    func getVerseChunks(size: Int) -> [WordInVerse] {
        let words = text.components(separatedBy: " ")
        var wordsInVerses = [WordInVerse]()
        
        var chunks = [String]()
        
        for i in stride(from: 0, to: words.count, by: size) {
            let chunk = words[i ..< Swift.min(i + size, words.count)]
            let chunkAsString = chunk.joined(separator: " ")
            chunks.append(chunkAsString)
        }
        
        for (index, chunk) in chunks.enumerated() {
            wordsInVerses.append(WordInVerse(id: index, word: chunk))
        }
        
        return wordsInVerses.shuffled()
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
