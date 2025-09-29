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
    
    func getVerseChunks(numberOfChunks: Int? = nil) -> [WordInVerse] {
        let words = text.components(separatedBy: " ")
        var wordsInVerses = [WordInVerse]()
        
        // If numberOfChunks is nil, make each word its own chunk
        let chunksCount = numberOfChunks ?? words.count
        guard chunksCount > 0 else { return [] }
        
        let baseChunkSize = words.count / chunksCount
        let remainder = words.count % chunksCount
        
        var start = 0
        for index in 0..<chunksCount {
            let currentChunkSize = baseChunkSize + (index < remainder ? 1 : 0)
            let end = start + currentChunkSize
            if start < words.count {
                let chunk = words[start..<Swift.min(end, words.count)].joined(separator: " ")
                wordsInVerses.append(WordInVerse(id: index, word: chunk))
            }
            start = end
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
