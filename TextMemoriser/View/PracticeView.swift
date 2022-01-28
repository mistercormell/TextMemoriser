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
    @State private var questionCount: Int = 10
    @State private var containGuessLocation: Bool = true
    @State private var containVerseArrange: Bool = true
    @State private var containGuessMissingWord: Bool = true
    
    var noQuestionTypesSelected: Bool {
        if !containVerseArrange && !containGuessLocation && !containGuessMissingWord {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        if practiceVm.isEnd || practiceVm.questions.isEmpty {
            VStack {
                Form {
                    Section() {
                        Stepper("No. Questions: \(questionCount)", value: $questionCount, in: 5...50)
                        Toggle("Guess the Reference", isOn: $containGuessLocation)
                        Toggle("Re-Arrange the Verse", isOn: $containVerseArrange)
                        Toggle("Guess the missing word", isOn: $containGuessMissingWord)
                    }
                    Button("Start Memorising") {
                        launchCustomQuestionSet()
                    }
                    .disabled(noQuestionTypesSelected)
                    .buttonStyle(BlueRoundedButton())
                }
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
        
    func launchCustomQuestionSet() {
        practiceVm.isEnd = false
        var questionSet: [Question] = []
        if containGuessLocation {
            questionSet.append(Question.guessLocation)
        }
        if containVerseArrange {
            questionSet.append(Question.arrangeVerse)
        }
        if containGuessMissingWord {
            questionSet.append(Question.missingWord)
        }
        practiceVm.questions = viewModel.constructQuestionSet(of: questionSet, count: questionCount)
    }

}

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeView()
    }
}
