//
//  VerseArrangeView.swift
//  TextMemoriser
//
//  Created by David Cormell on 04/01/2021.
//

import SwiftUI

struct VerseArrangeView: View {
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    @State var wordsInVerse = [WordInVerse]()
    @State var verseBeingBuilt = ""
    @EnvironmentObject var vm: StateController
    
    var body: some View {
        VStack {
            Text("\(vm.currentReference?.location.display ?? "")")
                .font(.largeTitle)
            Divider()
            Text(verseBeingBuilt)
            Spacer()
            Divider()
            HStack {
                Button("Check") {
                    checkAnswer()
                }
                Button("Reset") {
                    vm.wordsToPick = vm.currentReference?.wordsInVerse ?? []
                    wordsInVerse = []
                    verseBeingBuilt = ""
                }
            }
            Divider()
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(vm.wordsToPick, id: \.id) { word in
                    Button(action: {
                            wordsInVerse.append(word)
                        verseBeingBuilt = wordsInVerse.map { word in
                            word.word
                        }.joined(separator: " ")
                        vm.wordsToPick.removeAll {
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
        .onAppear(perform: loadReference)
        
    }
    
    func loadReference() {
        vm.loadReference()
    }
    
    func checkAnswer() {
        vm.nextQuestion()
    }
    

    
    
}

struct VerseArrangeView_Previews: PreviewProvider {
    static var previews: some View {
        VerseArrangeView()
    }
}
