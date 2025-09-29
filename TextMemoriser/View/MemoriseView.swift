//
//  MemoriseView.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 29/09/2025.
//

import SwiftUI

struct MemoriseView: View {
    let questionLimit = 3
    let passage: Passage
    @State private var question: Int = 1
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
                    GuessLocationView2(passage: passage, questionType: .bookOnly, question: $question)
                case 2:
                    GuessLocationView2(passage: passage, questionType: .bookAndChapter, question: $question)
                case 3:
                    GuessLocationView2(passage: passage, questionType: .bookAndChapterAndVerse, question: $question)
                default:
                    Text("Verse Memorised!")
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
            .onChange(of: question) {
                if $1 > questionLimit {
                    isMemorising = false
                }
                
            }
        }

    }
}

#Preview {
    MemoriseView(passage: Passage.example, isMemorising: .constant(true))
}
