//
//  PracticeViewModel.swift
//  TextMemoriser
//
//  Created by David Cormell on 27/01/2022.
//

import Foundation
import SwiftUI

@Observable
class PracticeViewModel {
    var questions: [(passage: Passage, type: Question)] = []
    var current: Int = 0
    
    func getQuestion() -> (passage: Passage, type: Question)? {
        if questions.isEmpty || current >= questions.count {
            return nil
        } else {
            return questions[current]
        }
    }
    

}
