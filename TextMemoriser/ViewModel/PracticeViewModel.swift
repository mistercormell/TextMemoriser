//
//  PracticeViewModel.swift
//  TextMemoriser
//
//  Created by David Cormell on 27/01/2022.
//

import Foundation
import SwiftUI

class PracticeViewModel: ObservableObject {
    @Published var questions: [(passage: Passage, type: Question)] = []
    @Published var current: Int = 0
    
    func getQuestion() -> (passage: Passage, type: Question)? {
        if questions.isEmpty || current >= questions.count {
            return nil
        } else {
            return questions[current]
        }
    }
    

}
