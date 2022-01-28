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
            Section(header: Text("Add Single Verse")) {
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
            }
            Section(header: Text("Add Verse Playlists")) {
                Button("All-time Favourites", action: {
                    for verse in VerseLocation.curatedVerses() {
                        vm.addVerseToLearningSet(verse)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                })
                Button("Proclaiming Salvation ", action: {
                    for verse in VerseLocation.proclaimingSalvation() {
                        vm.addVerseToLearningSet(verse)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                })
                Button("Becoming Christlike", action: {
                    for verse in VerseLocation.becomingChristlike() {
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
