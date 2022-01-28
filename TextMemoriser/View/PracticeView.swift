//
//  PracticeView.swift
//  TextMemoriser
//
//  Created by David Cormell on 09/01/2021.
//

import SwiftUI

struct PracticeView: View {
    @EnvironmentObject var viewModel: StateController
    @StateObject var practiceVm = PracticeViewModel()
    
    var body: some View {
        if practiceVm.isEnd || practiceVm.questions.isEmpty {
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
            let question = practiceVm.question
            if question.type == .guessLocation {
                GuessLocationView(practiceVm: practiceVm)
            } else if question.type == .missingWord {
                GuessMissingWordView(practiceVm: practiceVm)
            } else {
                VerseArrangeView(practiceVm: practiceVm, wordGroupSize: Int.random(in: 1...4))
            }
        }
        
    }
    
    func loadDailyChallenge() {
        practiceVm.isEnd = false
        practiceVm.questions = viewModel.constructQuestionSet(of: Question.missingWord)
    }

}

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeView()
    }
}
