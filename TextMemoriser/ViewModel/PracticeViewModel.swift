//
//  PracticeViewModel.swift
//  TextMemoriser
//
//  Created by David Cormell on 27/01/2022.
//

import Foundation

class PracticeViewModel: ObservableObject {
    @Published var questions: [(passage: Passage, type: Question)] = []
    @Published var current: Int = 0
    @Published var isEnd: Bool = false
    
    var question: (passage: Passage, type: Question) {
        questions[current]
    }
    
    func nextQuestion() {
        var nextIndex = current + 1
        if !questions.indices.contains(nextIndex) {
            isEnd = true
            current = 0
        } else {
            current = nextIndex
        }
    }
}
