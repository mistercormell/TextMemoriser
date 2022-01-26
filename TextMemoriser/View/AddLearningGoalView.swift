//
//  AddLearningGoalView.swift
//  TextMemoriser
//
//  Created by David Cormell on 13/02/2021.
//

import SwiftUI

struct AddLearningGoalView: View {
    @EnvironmentObject var vm: StateController
    @Environment(\.presentationMode) var presentationMode

    @State var bookChoice: Book = Book.Genesis
    @State var chapterChoice: Int = 1
    @State var verseChoice: Int = 1
    
    var body: some View {
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
            Button(action: {
                let verseToLearn = VerseLocation(book: bookChoice, chapter: chapterChoice, verse: verseChoice)
                vm.addVerseToLearningSet(verseToLearn)
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Add Verse to Learning Set")
            }
            Section {
                Button("Add curated verses to Learning Set", action: {
                    for verse in VerseLocation.curatedVerses() {
                        vm.addVerseToLearningSet(verse)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                })
            }
        }
        
    }
}

struct AddLearningGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddLearningGoalView()
    }
}
