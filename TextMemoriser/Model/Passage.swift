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
    
    func getVerseChunks(numberOfChunks: Int? = nil) -> ([WordInVerse],String) {
        let normalizedText = text.replacingOccurrences(
            of: "\\s+",
            with: " ",
            options: .regularExpression
        ).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let words = normalizedText.components(separatedBy: " ")
        var wordsInVerses = [WordInVerse]()
        
        // If numberOfChunks is nil, make each word its own chunk
        let chunksCount = numberOfChunks ?? words.count
        guard chunksCount > 0 else { return ([],"") }
        
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
        
        return (wordsInVerses.shuffled(),normalizedText)
    }
    
    func getTextWithMissingWord() -> (blankedText: String, missingWord: String) {
        let words = text.split(whereSeparator: \.isLetter.negation)
        let missingWord = String(words.randomElement() ?? "")
        let maskedMissingWord = String(repeating: "_", count: missingWord.count)
        let blankedText = text.replacingOccurrences(of: missingWord, with: maskedMissingWord)
        
        return (blankedText, missingWord)
    }
    
    func getTextWithMissingWords(percentToBlank: Double) -> (blankedText: String, missingWords: [String]) {
        // Collapse multiple whitespace/newlines into a single space
        let normalizedText = text.replacingOccurrences(
            of: "\\s+",
            with: " ",
            options: .regularExpression
        ).trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Split into words
        var words = normalizedText.components(separatedBy: " ")
        var missingWords: [String] = []

        // Determine how many words to blank out
        let numToBlank = max(1, Int(Double(words.count) * percentToBlank))
        
        // Randomly select unique indices to blank
        var indicesToBlank = Set<Int>()
        while indicesToBlank.count < numToBlank {
            indicesToBlank.insert(Int.random(in: 0..<words.count))
        }
        
        // Replace the selected words with underscores
        for index in indicesToBlank.sorted() {
            let word = words[index]
            let lettersOnly = word.filter { $0.isLetter }
            if !lettersOnly.isEmpty {
                missingWords.append(lettersOnly)
                let masked = String(repeating: "_", count: lettersOnly.count)
                words[index] = word.replacingOccurrences(
                    of: lettersOnly,
                    with: masked
                )
            }
        }
        
        return (words.joined(separator: " "), missingWords)
    }
    
    static func == (lhs: Passage, rhs: Passage) -> Bool {
        return lhs.text == rhs.text ? true : false
    }
        
    //#if DEBUG
    static let example = Passage(location: VerseLocation(book: Book.Colossians, chapter: 3, verse: 16), text: "Let the word of Christ dwell in you richly, teaching and admonishing one another in all wisdom, singing psalms and hymns and spiritual songs, with thankfulness in your hearts to God.", copyright: "ESV")
    //#endif
}
