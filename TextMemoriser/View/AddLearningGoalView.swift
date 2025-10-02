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
    @State private var selectedPlaylist: VersePlaylist?
    
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
                        ForEach(versePickerViewModel.endVerseRange, id: \.self) {
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
                updateVerseRanges()
            }
            .onChange(of: versePickerViewModel.chapterChoice) {
                updateVerseRanges()
            }
            .onChange(of: versePickerViewModel.verseChoice) {
                if versePickerViewModel.verseChoice > versePickerViewModel.verseEnd {
                    versePickerViewModel.verseEnd = versePickerViewModel.verseChoice
                }
            }
            .onChange(of: versePickerViewModel.verseEnd) {
                if versePickerViewModel.verseEnd < versePickerViewModel.verseChoice {
                    versePickerViewModel.verseChoice = versePickerViewModel.verseEnd
                }
            }
            Section(header: Text("Add Verse Playlists")) {
                Button("Creator's Favourites", action: {
                    selectedPlaylist = VersePlaylist(title: "Creator's Favourites", verses: VerseLocation.curatedVerses())
                })
                Button("Proclaiming Salvation ", action: {
                    selectedPlaylist = VersePlaylist(title: "Proclaiming Salvation", verses: VerseLocation.proclaimingSalvation())
                })
                Button("Becoming Christlike", action: {
                    selectedPlaylist = VersePlaylist(title: "Becoming Christlike", verses: VerseLocation.becomingChristlike())
                })
                Button("Being a Disciple", action: {
                    selectedPlaylist = VersePlaylist(title: "Being a Disciple", verses: VerseLocation.beingADisciple())
                })
                Button("Living the New Life", action: {
                    selectedPlaylist = VersePlaylist(title: "Living the New Life", verses: VerseLocation.livingTheNewLife())
                })
                Button("Relying on God", action: {
                    selectedPlaylist = VersePlaylist(title: "Relying on God", verses: VerseLocation.relyingOnGod())
                })
            }
        }
        .sheet(item: $selectedPlaylist) { playlist in
            PlaylistPreviewView(vm: PlaylistPreviewViewModel(title: playlist.title, translation: vm.translation, locations: playlist.verses)) {
                for verse in playlist.verses {
                    vm.addVerseToLearningSet(verse)
                }
                selectedPlaylist = nil
                self.presentationMode.wrappedValue.dismiss()
            }
            .presentationDetents([.medium,.large])
        }
        
    }
    
    func updateVerseRanges() {
        versePickerViewModel.updateRangeOfVersesInBookAndChapterChoice()
        if !versePickerViewModel.versesRange.contains(versePickerViewModel.verseChoice) {
            versePickerViewModel.verseChoice = versePickerViewModel.versesRange.first ?? 1
        }
        versePickerViewModel.updateRangeOfEndVersesInBookAndChapterChoice()
        if !versePickerViewModel.endVerseRange.contains(versePickerViewModel.verseEnd) {
            versePickerViewModel.verseEnd = versePickerViewModel.endVerseRange.upperBound
        }
    }
}

struct AddLearningGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddLearningGoalView()
    }
}
