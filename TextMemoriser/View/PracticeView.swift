//
//  PracticeView.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 30/09/2025.
//

import SwiftUI
import ConfettiSwiftUI

struct PracticeView: View {
    @EnvironmentObject var viewModel: StateController
    @StateObject var practiceVm = PracticeViewModel()
    @State private var questionCount: Int = 10
    @State private var confettiTrigger: Int = 0
    @State private var isShowingPracticeQuestionView: Bool = false
    
    var body: some View {
        VStack {
            Form {
                Stepper("No. Questions: \(questionCount)", value: $questionCount, in: 5...50)
                Button("Start Practicing") {
                    launchCustomQuestionSet()
                }
            }
            .fullScreenCover(isPresented: $isShowingPracticeQuestionView) {
                NavigationStack {
                    PracticeQuestionView(practiceVm: practiceVm, confettiTrigger: $confettiTrigger, isPresented: $isShowingPracticeQuestionView)
                }
                .confettiCannon(trigger: $confettiTrigger, colors: [BrandStyle.primary, BrandStyle.fish])
            }
        }

        .onChange(of: practiceVm.current) { newValue in
            if newValue >= questionCount {
                isShowingPracticeQuestionView = false
            }
        }
    }
        
    func launchCustomQuestionSet() {
        practiceVm.current = 0
        let questionSet: [Question] = [.arrangeVerse, .guessLocation, .missingWord]

        practiceVm.questions = viewModel.constructQuestionSet(of: questionSet, count: questionCount)
        isShowingPracticeQuestionView = true
    }

}

#Preview {
    PracticeView()
        .environmentObject(StateController())
}
