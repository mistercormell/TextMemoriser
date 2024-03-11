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
    @StateObject private var versePickerViewModel = VersePickerViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("Add Single Verse")) {
                Picker(selection: $versePickerViewModel.bookChoice, label: Text("Book"), content: {
                    ForEach(Book.allCases, id: \.self) {
                        Text($0.displayName)
                    }
                })
                Picker(selection: $versePickerViewModel.chapterChoice, label: Text("Chapter"), content: {
                    ForEach(versePickerViewModel.chapterRange, id: \.self) {
                        Text("\($0)")
                    }
                })
                Picker(selection: $versePickerViewModel.verseChoice, label: Text("Verse"), content: {
                    ForEach(versePickerViewModel.versesRange, id: \.self) {
                        Text("\($0)")
                    }
                })
                if !versePickerViewModel.singleVerse {
                    Picker(selection: $versePickerViewModel.verseEnd, label: Text("End Verse"), content: {
                        ForEach(versePickerViewModel.verseChoice...versePickerViewModel.versesRange.upperBound, id: \.self) {
                            Text("\($0)")
                        }
                    })
                }
                Toggle("Single Verse", isOn: $versePickerViewModel.singleVerse)

                Button(action: {
                    if versePickerViewModel.singleVerse {
                        let verseToLearn = VerseLocation(book: versePickerViewModel.bookChoice, chapter: versePickerViewModel.chapterChoice, verse: versePickerViewModel.verseChoice)
                        vm.addVerseToLearningSet(verseToLearn)
                    } else {
                        for verse in versePickerViewModel.verseChoice ... versePickerViewModel.verseEnd {
                            let verseToLearn = VerseLocation(book: versePickerViewModel.bookChoice, chapter: versePickerViewModel.chapterChoice, verse: verse)
                            vm.addVerseToLearningSet(verseToLearn)
                        }
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add Verse/s to Learning Set")
                }
            }
            .onChange(of: versePickerViewModel.bookChoice) {
                versePickerViewModel.updateRangeOfChaptersInBookChoice()
                if !versePickerViewModel.chapterRange.contains(versePickerViewModel.chapterChoice) {
                    versePickerViewModel.chapterChoice = versePickerViewModel.chapterRange.first ?? 1
                }
                versePickerViewModel.updateRangeOfVersesInBookAndChapterChoice()
                if !versePickerViewModel.versesRange.contains(versePickerViewModel.verseChoice) {
                    versePickerViewModel.verseChoice = versePickerViewModel.versesRange.first ?? 1
                }
            }
            .onChange(of: versePickerViewModel.chapterChoice) {
                versePickerViewModel.updateRangeOfVersesInBookAndChapterChoice()
                if !versePickerViewModel.versesRange.contains(versePickerViewModel.verseChoice) {
                    versePickerViewModel.verseChoice = versePickerViewModel.versesRange.first ?? 1
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
