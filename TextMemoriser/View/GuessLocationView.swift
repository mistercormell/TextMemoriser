//
//  GuessLocationView.swift
//  TextMemoriser
//
//  Created by David Cormell on 03/01/2021.
//

import SwiftUI

struct GuessLocationView: View {
    @EnvironmentObject var vm: StateController
    @StateObject var questionFeedback = QuestionFeedback()
    @ObservedObject var practiceVm: PracticeViewModel
    @State var chapter = 1
    @State var verse = 1
    @State var selectedBook = Book.Genesis
        
    var body: some View {
        NavigationView {
            Content(passage: practiceVm.question.passage, check: checkAnswer, bookChoice: $selectedBook, chapterChoice: $chapter, verseChoice: $verse)
                
                .navigationBarTitle("Guess the Location")
                .alert(isPresented: $questionFeedback.isShowing, content: {
                    Alert(title: Text("\(questionFeedback.alertTitle)"), message: Text("\(questionFeedback.alertBody)\n\nYour score is: \(vm.score)"), dismissButton: .default(Text("OK")) { practiceVm.nextQuestion() } )})
        }
    }
    
    func checkAnswer() {
        if selectedBook == practiceVm.question.passage.location.book && chapter == practiceVm.question.passage.location.chapter && verse == practiceVm.question.passage.location.verse {
            vm.score += 1
            questionFeedback.alertTitle = "Correct"
            questionFeedback.alertBody = "Keep on going!"
        } else {
            questionFeedback.alertTitle = "Not quite!"
            questionFeedback.alertBody = "\(practiceVm.question.passage.location.display)"
        }
        questionFeedback.isShowing = true
    }
}

extension GuessLocationView {
    struct Content: View {
        let passage: Passage?
        let check: () -> Void
        
        @Binding var bookChoice: Book
        @Binding var chapterChoice: Int
        @Binding var verseChoice: Int
        
        var body: some View {
            VStack {
                if let passage = passage {
                    Text("\(passage.text) (\(passage.copyright))")
                        .padding()
                } else {
                    ProgressView("Loading verse...")
                }
                Form {
                    Picker(selection: $bookChoice, label: Text("Book"), content: {
                        ForEach(Book.allCases, id: \.self) {
                            Text($0.displayName)
                        }
                    })
                    Picker(selection: $chapterChoice, label: Text("Chapter"), content: {
                        ForEach(0 ... 150, id: \.self) {
                            Text("\($0)")
                        }
                    })
                    Picker(selection: $verseChoice, label: Text("Verse"), content: {
                        ForEach(0 ... 60, id: \.self) {
                            Text("\($0)")
                        }
                    })
                }
                Button("Check", action: check)
                    .padding()
            }
        }
    }
}

struct GuessLocationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GuessLocationView.Content(passage: Passage.example, check: {}, bookChoice: .constant(Book.Genesis), chapterChoice: .constant(1), verseChoice: .constant(5))
                .navigationBarTitle("Guess the Location")
        }

    }
}
