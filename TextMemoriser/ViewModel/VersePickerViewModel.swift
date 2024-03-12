//
//  VersePickerViewModel.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 11/03/2024.
//

import Foundation

class VersePickerViewModel: ObservableObject {
    @Published var bookChoice: Book = Book.Genesis
    @Published var chapterChoice: Int = 1
    @Published var verseChoice: Int = 1
    @Published var verseEnd: Int = 1
    
    @Published var chapterRange: ClosedRange<Int> = 1...50
    @Published var versesRange: ClosedRange<Int> = 1...31
    @Published var endVerseRange: ClosedRange<Int> = 1...31
    @Published var singleVerse: Bool = true
    
    let bibleMetadata = BibleMetadata()
    
    func updateRangeOfChaptersInBookChoice() {
        chapterRange = 1...bookChoice.numberOfChapters
    }
    
    func updateRangeOfVersesInBookAndChapterChoice() {
        versesRange = 1...bibleMetadata.numberOfVerses(in: bookChoice, chapter: chapterChoice)
    }
    
    func updateRangeOfEndVersesInBookAndChapterChoice() {
        endVerseRange = verseChoice...versesRange.upperBound
    }
}
