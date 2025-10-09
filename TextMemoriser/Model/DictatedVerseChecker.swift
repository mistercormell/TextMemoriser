//
//  DictatedVerseChecker.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 09/10/2025.
//

import Foundation

struct VerseComparison {
    let targetVerse: String
    let spokenVerse: String
    let isMatch: Bool
    let accuracy: Double
    let matchedWords: Int
    let totalWords: Int
    let wordMatches: [(target: String, spoken: String?, isMatch: Bool)]
}

struct DictatedVerseChecker {
    static func compare(target: String, spoken: String) -> VerseComparison {
        // Normalize both strings for comparison
        let normalizedTarget = normalize(target)
        let normalizedSpoken = normalize(spoken)
        
        // Split into words
        let targetWords = normalizedTarget.split(separator: " ").map(String.init)
        let spokenWords = normalizedSpoken.split(separator: " ").map(String.init)
        
        // Calculate word-level matches
        let wordMatches = compareWords(targetWords: targetWords, spokenWords: spokenWords)
        let matchedCount = wordMatches.filter { $0.isMatch }.count
        let totalWords = targetWords.count
        
        // Calculate accuracy percentage
        let accuracy = totalWords > 0 ? Double(matchedCount) / Double(totalWords) : 0.0
        
        // Consider it a "match" if accuracy is 95% or higher
        let isMatch = accuracy >= 0.95
        
        return VerseComparison(
            targetVerse: target,
            spokenVerse: spoken,
            isMatch: isMatch,
            accuracy: accuracy,
            matchedWords: matchedCount,
            totalWords: totalWords,
            wordMatches: wordMatches
        )
    }
    
    private static func compareWords(targetWords: [String], spokenWords: [String]) -> [(target: String, spoken: String?, isMatch: Bool)] {
        var results: [(target: String, spoken: String?, isMatch: Bool)] = []
        var spokenIndex = 0
        
        for targetWord in targetWords {
            // Try to find a match in the remaining spoken words (with some lookahead)
            var foundMatch = false
            let lookaheadRange = min(3, spokenWords.count - spokenIndex) // Look ahead up to 3 words
            
            for offset in 0..<max(1, lookaheadRange) {
                let checkIndex = spokenIndex + offset
                if checkIndex < spokenWords.count {
                    let spokenWord = spokenWords[checkIndex]
                    
                    // Check for exact match or fuzzy match
                    if isWordMatch(targetWord, spokenWord) {
                        results.append((target: targetWord, spoken: spokenWord, isMatch: true))
                        spokenIndex = checkIndex + 1
                        foundMatch = true
                        break
                    }
                }
            }
            
            if !foundMatch {
                // No match found for this target word
                results.append((target: targetWord, spoken: nil, isMatch: false))
                // Still advance spoken index if we skipped a word
                if spokenIndex < spokenWords.count {
                    spokenIndex += 1
                }
            }
        }
        
        return results
    }
    
    private static func isWordMatch(_ word1: String, _ word2: String) -> Bool {
        // Exact match
        if word1 == word2 {
            return true
        }
        
        // Allow common article substitutions (a, an, the)
        let articles = Set(["a", "an", "the"])
        if articles.contains(word1) && articles.contains(word2) {
            return true
        }
        
        // Handle common contractions and their expansions
        let contractionPairs: [(String, String)] = [
            ("cant", "cannot"),
            ("wont", "will not"),
            ("dont", "do not"),
            ("doesnt", "does not"),
            ("didnt", "did not"),
            ("wouldnt", "would not"),
            ("shouldnt", "should not"),
            ("couldnt", "could not"),
            ("isnt", "is not"),
            ("arent", "are not"),
            ("wasnt", "was not"),
            ("werent", "were not"),
            ("hasnt", "has not"),
            ("havent", "have not"),
            ("hadnt", "had not"),
            ("im", "i am"),
            ("youre", "you are"),
            ("hes", "he is"),
            ("shes", "she is"),
            ("its", "it is"),
            ("were", "we are"),
            ("theyre", "they are"),
            ("ive", "i have"),
            ("youve", "you have"),
            ("weve", "we have"),
            ("theyve", "they have"),
            ("ill", "i will"),
            ("youll", "you will"),
            ("hell", "he will"),
            ("shell", "she will"),
            ("well", "we will"),
            ("theyll", "they will")
        ]
        
        // Check if words match via contraction pairs (either direction)
        for (contracted, expanded) in contractionPairs {
            if (word1 == contracted && word2 == expanded) || (word1 == expanded && word2 == contracted) {
                return true
            }
        }
        
        return false
    }
    
    private static func normalize(_ text: String) -> String {
        return text
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "[^a-z0-9\\s]", with: "", options: .regularExpression) // Remove punctuation
                        .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression) // Normalize whitespace
    }
}
