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
        GridItem(.adaptive(minimum: 70))
    ]
    
    @State private var currentReferenceIndex = 0
    @State var wordsToPick = [WordInVerse]()
    @State var wordsInVerse = [WordInVerse]()
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(wordsInVerse, id: \.id) { word in
                    Button(word.word) {
                        wordsToPick.append(word)
                        wordsInVerse.removeAll {
                            $0.id == word.id
                        }
                    }
                }
            }
            Spacer()
            LazyVGrid(columns: columns2, spacing: 20) {
                ForEach(wordsToPick, id: \.id) { word in
                    Button(action: {
                            wordsInVerse.append(word)
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
