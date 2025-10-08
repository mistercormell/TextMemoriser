//
//  MemorisationProgress.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 29/09/2025.
//

import Foundation
import SwiftUI

class MemorisationProgress: ObservableObject {
    var progress: [VerseLocation:VerseMastery] = [:]
    let levelNames = [
        "Seedling", "Learner", "Follower", "Scribe",
        "Disciple", "Shepherd", "Teacher", "Evangelist",
        "Overcomer", "Lightbearer", "Pillar", "Crown"
    ]

    let levels = [
        50, 150, 300, 500,
        800, 1200, 1800, 2600,
        3600, 5000, 7000, Int.max
    ]
    
    init() {
        load()
    }
    
    func correctAnswer(verse: VerseLocation) {
        if let existingProgress = progress[verse] {
            progress[verse] = VerseMastery(attempts: existingProgress.attempts + 1, correct: existingProgress.correct + 1, lastStudied: Date.now)
        } else {
            progress[verse] = VerseMastery(attempts: 1, correct: 1, lastStudied: Date.now)
        }
        save()
    }
    
    func incorrectAnswer(verse: VerseLocation) {
        if let existingProgress = progress[verse] {
            progress[verse] = VerseMastery(attempts: existingProgress.attempts + 1, correct: existingProgress.correct, lastStudied: Date.now)
        } else {
            progress[verse] = VerseMastery(attempts: 1, correct: 0, lastStudied: Date.now)
        }
        save()
    }
    
    func getMasteryScore(for verse: VerseLocation) -> Double {
        if let mastery = progress[verse] {
            return mastery.getMasteryLevel()
        } else { return 0.0 }
    }
    
    func getPracticeVerses() -> [VerseLocation] {
        return progress.sorted(by: {
            $0.value.getMasteryLevel() > $1.value.getMasteryLevel()
        })
        .prefix(10)
        .map({
            $0.key
        })
    }
    
    func getGlobalScore() -> Int {
        var score = 0
        for item in progress.values {
            score += item.attempts * 1
            score += item.correct * 5
        }
        
        return score
    }
    
    // Determine the current level
    func getCurrentLevel(globalScore: Int) -> Int {
        for (index, threshold) in levels.enumerated() {
            if globalScore < threshold {
                return index + 1
            }
        }
        return levels.count
    }
    
    func getNextLevelName(currentLevel: Int) -> String? {
        let levelIndex = currentLevel - 1
        // Check if there's a next level
        guard levelIndex + 1 < levelNames.count else { return nil }
        return levelNames[levelIndex + 1]
    }
    
    func getCurrentLevelName(level: Int) -> String {
        let levelIndex = min(level - 1, levelNames.count - 1)
        return levelNames[levelIndex]
    }
        
        // Calculate progress toward next level
    func getProgressFraction(currentLevel: Int, globalScore: Int) -> Double {
        let levelIndex = min(currentLevel - 1, levels.count - 1)
        let lowerBound = levelIndex == 0 ? 0 : levels[levelIndex - 1]
        let upperBound = levels[levelIndex]
        
        // Avoid division by zero
        guard upperBound - lowerBound > 0 else { return 1.0 }
        
        return min(Double(globalScore - lowerBound) / Double(upperBound - lowerBound), 1.0)
    }
            
    //todo persistence
    func save() {
        FileManager.default.save(to: "progress.json", object: progress)
    }
    
    func load() {
        if let loadedMemorisationProgress: [VerseLocation:VerseMastery] = FileManager.default.load(from: "progress.json") {
            progress = loadedMemorisationProgress
        }
    }
}
