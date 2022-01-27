//
//  PracticeView.swift
//  TextMemoriser
//
//  Created by David Cormell on 09/01/2021.
//

import SwiftUI

struct PracticeView: View {
    @EnvironmentObject var viewModel: StateController
    @State var questions: [(passage: Passage, type: Question)] = []
    @State var current: Int = 0
    
    var body: some View {
        if questions.isEmpty || current > questions.count {
            HStack {
                Button("Start Daily Challenge") {
                    loadDailyChallenge()
                }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            }
        } else {
            let question = questions[current]
            if question.type == .guessLocation {
                GuessLocationView(nextQuestion: nextQuestion, passage: question.passage)
            } else if question.type == .missingWord {
                GuessMissingWordView(nextQuestion: nextQuestion, passage: question.passage)
            } else {
                VerseArrangeView(wordGroupSize: Int.random(in: 1...4), nextQuestion: nextQuestion, passage: question.passage)
            }
        }
        
    }
    
    func nextQuestion() {
        current += 1
    }
    
    func loadDailyChallenge() {
        questions = viewModel.constructQuestionSet()
    }

}

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeView()
    }
}
