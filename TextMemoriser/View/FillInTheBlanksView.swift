//
//  FillInTheBlanksView.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 29/09/2025.
//

import SwiftUI

struct FillInTheBlanksView: View {
    let passage: Passage
    let percentageBlank: Double
    
    @State var textWithBlanks: String = ""
    @State var missingWords: [String] = []
    @State var userEnteredMissingWords: [String] = []
    
    @StateObject var questionFeedback = QuestionFeedback()
    
    @Environment(MemorisationProgress.self) var memorisationProgress: MemorisationProgress
    
    @Binding var question: Int
    @Binding var confettiTrigger: Int
    
    var body: some View {
        VStack {
            Text("\(passage.displayLocationWithCopyright)")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(textWithBlanks)
                .padding()
                .alert(isPresented: $questionFeedback.isShowing, content: {
                    Alert(title: Text("\(questionFeedback.alertTitle)"), message: Text("\(questionFeedback.alertBody)"), dismissButton: .default(Text("OK")) { question += 1
                    } )})
            Form {
                ForEach(missingWords.indices, id: \.self) { index in
                    TextField("Missing Word: \(index +  1)", text: $userEnteredMissingWords[index])
                }
            }
            Button("Check") {
                if missingWords.elementsEqual(userEnteredMissingWords, by: { $0.lowercased() == $1.lowercased() }) {
                    memorisationProgress.correctAnswer(verse: passage.location)
                    confettiTrigger += 1
                    question += 1
                } else {
                    questionFeedback.alertTitle = "Incorrect"
                    questionFeedback.alertBody = "The correct words were \(missingWords.joined(separator: ", "))"
                    memorisationProgress.incorrectAnswer(verse: passage.location)
                }
                
                questionFeedback.isShowing = true
            }
            .padding()
        }

        .onAppear {
            let setup = passage.getTextWithMissingWords(percentToBlank: percentageBlank)
            textWithBlanks = setup.blankedText
            missingWords = setup.missingWords
            userEnteredMissingWords = Array(repeating: "", count: missingWords.count)
        }
        
    }

}

#Preview {
    FillInTheBlanksView(passage: Passage.example, percentageBlank: 0.1, question: .constant(1), confettiTrigger: .constant(1))
        .environment(MemorisationProgress())
}
