//
//  PracticeQuestionView.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 01/10/2025.
//

import SwiftUI

struct PracticeQuestionView: View {
    @Bindable var practiceVm: PracticeViewModel
    @Binding var confettiTrigger: Int
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ProgressView(value: Double(practiceVm.current), total: Double(practiceVm.questions.count))
                .progressViewStyle(.linear)
                .tint(BrandStyle.primary)
                .padding()
            if let question = practiceVm.getQuestion() {
                switch question.type {
                case .guessLocation:
                    // Use .id to force refresh whenever current changes
                    GuessLocationView(
                        passage: question.passage,
                        questionType: GuessLocationQuestionType.allCases.randomElement()!,
                        confettiTrigger: $confettiTrigger,
                        question: $practiceVm.current
                    )
                    .id(practiceVm.current)
                    
                case .missingWord:
                    FillInTheBlanksView(
                        passage: question.passage,
                        percentageBlank: 0.35,
                        question: $practiceVm.current,
                        confettiTrigger: $confettiTrigger
                    )
                    .id(practiceVm.current)
                    
                case .arrangeVerse:
                    let chunkCountOptions: [Int?] = [5, 8, nil]
                    ArrangeTheVerseView(
                        question: $practiceVm.current,
                        confettiTrigger: $confettiTrigger,
                        chunks: chunkCountOptions.randomElement()!,
                        passage: question.passage
                    )
                    .id(practiceVm.current)
                }
            } else {
                Text("Practice complete!")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

#Preview {
    PracticeQuestionView(practiceVm: PracticeViewModel(), confettiTrigger: .constant(1))
}
