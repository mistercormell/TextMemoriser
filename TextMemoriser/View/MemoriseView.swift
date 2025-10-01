//
//  MemoriseView.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 29/09/2025.
//

import SwiftUI
import ConfettiSwiftUI

struct MemoriseView: View {
    let questionLimit = 9
    let passage: Passage
    @State private var question: Int = 1
    @State private var confettiTrigger: Int = 0
    @State private var finalConfettiTrigger: Int = 0
    @Binding var isMemorising: Bool
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ProgressView(value: Double(question), total: Double(questionLimit))
                    .progressViewStyle(.linear)
                    .padding()
                switch question {
                case 1:
                    GuessLocationView(passage: passage, questionType: .bookOnly, confettiTrigger: $confettiTrigger, question: $question)
                case 2:
                    FillInTheBlanksView(passage: passage, percentageBlank: 0.1, question: $question, confettiTrigger: $confettiTrigger)
                case 3:
                    ArrangeTheVerseView(question: $question, confettiTrigger: $confettiTrigger, chunks: 5, passage: passage)
                case 4:
                    GuessLocationView(passage: passage, questionType: .bookAndChapter, confettiTrigger: $confettiTrigger, question: $question)
                case 5:
                    FillInTheBlanksView(passage: passage, percentageBlank: 0.2, question: $question, confettiTrigger: $confettiTrigger)
                case 6:
                    ArrangeTheVerseView(question: $question, confettiTrigger: $confettiTrigger, chunks: 8, passage: passage)
                case 7:
                    GuessLocationView(passage: passage, questionType: .bookAndChapterAndVerse, confettiTrigger: $confettiTrigger, question: $question)
                case 8:
                    FillInTheBlanksView(passage: passage, percentageBlank: 0.35, question: $question, confettiTrigger: $confettiTrigger)
                case 9:
                    ArrangeTheVerseView(wordsToPick: passage.getVerseChunks().0, question: $question, confettiTrigger: $confettiTrigger, chunks: nil, passage: passage)
                default:
                    Text("Verse Memorised!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        
                }
            }
            .confettiCannon(trigger: $confettiTrigger, colors: [BrandStyle.primary, BrandStyle.secondary])
            .confettiCannon(trigger: $finalConfettiTrigger, num: 200, confettis: [.text("🥖"), .text("🐟")])
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
            .onChange(of: question) {
                if $1 > questionLimit {
                    finalConfettiTrigger += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        isMemorising = false
                    }
                }
                
            }
        }

    }
}

#Preview {
    MemoriseView(passage: Passage.example, isMemorising: .constant(true))
}
