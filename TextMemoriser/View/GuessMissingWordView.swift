//
//  GuessMissingWordView.swift
//  TextMemoriser
//
//  Created by David Cormell on 16/02/2021.
//

import SwiftUI

struct GuessMissingWordView: View {
    @EnvironmentObject var vm: StateController
    @StateObject var questionFeedback = QuestionFeedback()
    @State var missingWord: String = ""
    
    var body: some View {
        NavigationView {
            Content(verseWithBlank: vm.textWithMissingWord.blankedText , check: checkAnswer, missingWord: $missingWord)
                .navigationTitle(vm.currentReference?.displayLocationWithCopyright ?? "")
                .alert(isPresented: $questionFeedback.isShowing, content: {
                    Alert(title: Text("\(questionFeedback.alertTitle)"), message: Text("\(questionFeedback.alertBody)\n\nYour score is: \(vm.score)"), dismissButton: .default(Text("OK")) {vm.nextQuestion()} )})
                .onAppear(perform: {
                    vm.loadReference()
                    vm.textWithMissingWord = vm.currentReference?.getTextWithMissingWord() ?? ("","")
                })
        }
    }
    
    func checkAnswer() {
        if missingWord.caseInsensitiveCompare(vm.textWithMissingWord.missingWord) == .orderedSame {
            questionFeedback.alertTitle = "Correct"
            vm.score += 1
            questionFeedback.alertBody = ""
        } else {
            questionFeedback.alertTitle = "The correct answer is"
            questionFeedback.alertBody = "\(vm.textWithMissingWord.missingWord)"
        } 
        questionFeedback.isShowing = true
    }
}

extension GuessMissingWordView {
    struct Content: View {
        let verseWithBlank: String
        let check: () -> Void
        
        @Binding var missingWord: String
        
        var body: some View {
            VStack {
                Text(verseWithBlank)
                    .padding()
                Spacer()
                Form {
                    TextField("Enter the missing word", text: $missingWord)
                    Button(action: check) {
                        Text("Check")
                    }
                }
            }
        }
    }
}

struct GuessMissingWordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GuessMissingWordView.Content(verseWithBlank: "In the _________, God made the heavens and the earth.", check: {}, missingWord: .constant(""))
                .navigationBarTitle("Genesis 1:1 (ESV)")
                .environmentObject(StateController())
        }
    }
}
