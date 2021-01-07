//
//  VerseArrangeView.swift
//  TextMemoriser
//
//  Created by David Cormell on 04/01/2021.
//

import SwiftUI

struct VerseArrangeView: View {
    let references = ReferenceFactory.makeReferences()
    let columns = [
        GridItem(.adaptive(minimum: 70))
    ]
    
    let columns2 = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    @State private var currentReferenceIndex = 0
    @State var wordsToPick = [WordInVerse]()
    @State var wordsInVerse = [WordInVerse]()
    @State var verseBeingBuilt = ""
    
    var body: some View {
        VStack {
            Text("\(references[currentReferenceIndex].display())")
                .font(.largeTitle)
            Divider()
            Text(verseBeingBuilt)
            Spacer()
            Divider()
            HStack {
                Button("Skip") {
                    loadVerse()
                }
                Button("Reset") {
                    wordsToPick = wordsInVerses(verse: references[currentReferenceIndex].text)
                    wordsInVerse = []
                    verseBeingBuilt = ""
                }
            }
            Divider()
            LazyVGrid(columns: columns2, spacing: 20) {
                ForEach(wordsToPick, id: \.id) { word in
                    Button(action: {
                            wordsInVerse.append(word)
                        verseBeingBuilt = wordsInVerse.map { word in
                            word.word
                        }.joined(separator: " ")
                        wordsToPick.removeAll {
                            $0.id == word.id
                        }
                    }) {
                        Text(word.word)
                            .padding(5)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                }
            }
        }
        .onAppear(perform: loadVerse)
        
    }
    
    func loadVerse() {
        currentReferenceIndex = Int.random(in: 0..<references.count)
        let reference = references[currentReferenceIndex]
        
        wordsToPick = wordsInVerses(verse: reference.text)
    }
    
    func wordsInVerses(verse: String) -> [WordInVerse] {
        let words = verse.components(separatedBy: " ").shuffled()
        var wordsInVerses = [WordInVerse]()
        
        for (index, word) in words.enumerated() {
            wordsInVerses.append(WordInVerse(id: index, word: word))
        }
        
        return wordsInVerses
    }
    
    
}

struct VerseArrangeView_Previews: PreviewProvider {
    static var previews: some View {
        VerseArrangeView()
    }
}
