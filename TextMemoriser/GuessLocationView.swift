//
//  GuessLocationView.swift
//  TextMemoriser
//
//  Created by David Cormell on 03/01/2021.
//

import SwiftUI

struct GuessLocationView: View {
    @EnvironmentObject var vm: StateController
        
    var body: some View {
        NavigationView {
            Content(passage: vm.currentReference, check: checkAnswer, bookChoice: $vm.selectedBook, chapterChoice: $vm.chapter, verseChoice: $vm.verse)
                .onAppear(perform: vm.loadReference)
                .navigationBarTitle("Guess the Location")
                .alert(isPresented: $vm.showingScore, content: {
                        Alert(title: Text("\(vm.alertTitle)"), message: Text("Your score is: \(vm.score)"), dismissButton: .default(Text("OK")) {nextQuestion()} )})
        }
    }
    
    func nextQuestion() {
        vm.nextQuestion()
    }
    
    func checkAnswer() {
        if let correctReference = vm.currentReference {
            if vm.selectedBook.rawValue == correctReference.location.book && vm.chapter == correctReference.location.chapter && vm.verse == correctReference.location.verse {
                vm.alertTitle = "Correct"
                vm.score += 1
            } else {
                vm.alertTitle = "Wrong!"
            }
            vm.showingScore = true
            vm.loadReference()
        }
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
                    Text(passage.text)
                        .padding()
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
                Button("Check Answer", action: check)
            }
        }
    }
}

struct GuessLocationView_Previews: PreviewProvider {
    static var previews: some View {
        GuessLocationView()
    }
}
