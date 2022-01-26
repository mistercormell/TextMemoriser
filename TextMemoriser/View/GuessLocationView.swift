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
                
                .navigationBarTitle("Guess the Location")
                .alert(isPresented: $vm.showingScore, content: {
                        Alert(title: Text("\(vm.alertTitle)"), message: Text("Your score is: \(vm.score)"), dismissButton: .default(Text("OK")) {vm.nextQuestion()} )})
        }
        .onAppear(perform: vm.loadReference)
    }
    
    func checkAnswer() {
        if let correctReference = vm.currentReference {
            if vm.selectedBook == correctReference.location.book && vm.chapter == correctReference.location.chapter && vm.verse == correctReference.location.verse {
                vm.alertTitle = "Correct"
                vm.score += 1
            } else {
                vm.alertTitle = "Wrong!"
            }
            vm.showingScore = true
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
