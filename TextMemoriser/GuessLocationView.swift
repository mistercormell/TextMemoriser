//
//  GuessLocationView.swift
//  TextMemoriser
//
//  Created by David Cormell on 03/01/2021.
//

import SwiftUI

struct GuessLocationView: View {
    let references = ReferenceFactory.makeReferences()
    
    let books = ["Genesis", "Exodus", "Leviticus", "John", "Colossians", "1 Timothy", "2 Timothy"]

    @State var chapter = 1
    @State var verse = 1
    @State var selectedBook = 0
    @State var currentReferenceIndex = 0
    @State var alertTitle = ""
    @State var showingScore = false
    @State var score = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Text(references[currentReferenceIndex].text)
                    .padding()
                Form {
                    Picker(selection: $selectedBook, label: Text("Book"), content: {
                        ForEach(0 ..< books.count) {
                            Text(books[$0])
                        }
                    })
                    Picker(selection: $chapter, label: Text("Chapter"), content: {
                        ForEach(0 ... 150, id: \.self) {
                            Text("\($0)")
                        }
                    })
                    Picker(selection: $verse, label: Text("Verse"), content: {
                        ForEach(0 ... 60, id: \.self) {
                            Text("\($0)")
                        }
                    })
                }
                Button("Check Answer", action: {
                    let correctReference = references[currentReferenceIndex]
                    if books[selectedBook] == correctReference.book && chapter == correctReference.chapter && verse == correctReference.verse {
                        alertTitle = "Correct"
                        score += 1
                    } else {
                        alertTitle = "Wrong!"
                    }
                    showingScore = true
                    currentReferenceIndex = Int.random(in: 0..<references.count)
                })
            }
            .navigationBarTitle("Guess the Location")
            .alert(isPresented: $showingScore, content: {
                Alert(title: Text("\(alertTitle)"), message: Text("Your score is: \(score)"), dismissButton: .default(Text("OK")))
            })
        }.onAppear(perform: {
            let adaptor = EsvBibleAdaptor()
            adaptor.fetchVerseWithReference(book: "2Timothy", chapter: 1, verse: 7)
        })
            

    }
}

struct GuessLocationView_Previews: PreviewProvider {
    static var previews: some View {
        GuessLocationView()
    }
}
