//
//  MemorisationProgress.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 29/09/2025.
//

import Foundation
import SwiftUI

@Observable
class MemorisationProgress {
    var progress: [VerseLocation:VerseMastery] = [:]
    
    func correctAnswer(verse: VerseLocation) {
        if let existingProgress = progress[verse] {
            progress[verse] = VerseMastery(attempts: existingProgress.attempts + 1, correct: existingProgress.correct + 1, lastStudied: Date.now)
        } else {
            progress[verse] = VerseMastery(attempts: 1, correct: 1, lastStudied: Date.now)
        }
    }
    
    func incorrectAnswer(verse: VerseLocation) {
        if let existingProgress = progress[verse] {
            progress[verse] = VerseMastery(attempts: existingProgress.attempts + 1, correct: existingProgress.correct, lastStudied: Date.now)
        } else {
            progress[verse] = VerseMastery(attempts: 1, correct: 0, lastStudied: Date.now)
        }
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
    
    //todo persistence
    func save() {
        
    }
    
    func load() {
        
    }
}
