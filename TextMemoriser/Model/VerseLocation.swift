//
//  VerseLocation.swift
//  TextMemoriser
//
//  Created by David Cormell on 09/01/2021.
//

import Foundation

struct VerseLocation: Codable, Identifiable, Equatable, Hashable {
    let book: Book
    let chapter: Int
    let verse: Int
    
    var display: String {
        "\(book.displayName) \(chapter):\(verse)"
    }
    
    var id: String {
        display
    }
    
    static func == (lhs: VerseLocation, rhs: VerseLocation) -> Bool {
        return lhs.id == rhs.id ? true : false
    }
    
    static func curatedVerses() -> [VerseLocation] {
        var curatedVerses = [VerseLocation]()
        curatedVerses.append(VerseLocation(book: Book.Colossians, chapter: 3, verse: 16))
        curatedVerses.append(VerseLocation(book: Book.Jeremiah, chapter: 29, verse: 11))
        curatedVerses.append(VerseLocation(book: Book.Philippians, chapter: 4, verse: 4))
        curatedVerses.append(VerseLocation(book: Book.John, chapter: 10, verse: 10))
        curatedVerses.append(VerseLocation(book: Book.Matthew, chapter: 6, verse: 34))
        curatedVerses.append(VerseLocation(book: Book.John1, chapter: 5, verse: 14))
        curatedVerses.append(VerseLocation(book: Book.Proverbs, chapter: 3, verse: 5))
        curatedVerses.append(VerseLocation(book: Book.Malachi, chapter: 4, verse: 2))
        
        return curatedVerses
    }
    
    static func becomingChristlike() -> [VerseLocation] {
        var curatedVerses = [VerseLocation]()
        curatedVerses.append(VerseLocation(book: Book.John, chapter: 13, verse: 34))
        curatedVerses.append(VerseLocation(book: Book.John, chapter: 13, verse: 35))
        curatedVerses.append(VerseLocation(book: Book.John1, chapter: 3, verse: 18))
        curatedVerses.append(VerseLocation(book: Book.Philippians, chapter: 2, verse: 3))
        curatedVerses.append(VerseLocation(book: Book.Philippians, chapter: 2, verse: 4))
        curatedVerses.append(VerseLocation(book: Book.Peter1, chapter: 5, verse: 5))
        curatedVerses.append(VerseLocation(book: Book.Peter1, chapter: 5, verse: 6))
        curatedVerses.append(VerseLocation(book: Book.Ephesians, chapter: 5, verse: 3))
        curatedVerses.append(VerseLocation(book: Book.Peter1, chapter: 2, verse: 11))
        curatedVerses.append(VerseLocation(book: Book.Leviticus, chapter: 19, verse: 11))
        curatedVerses.append(VerseLocation(book: Book.Acts, chapter: 24, verse: 16))
        curatedVerses.append(VerseLocation(book: Book.Hebrews, chapter: 11, verse: 6))
        curatedVerses.append(VerseLocation(book: Book.Romans, chapter: 4, verse: 20))
        curatedVerses.append(VerseLocation(book: Book.Romans, chapter: 4, verse: 21))
        curatedVerses.append(VerseLocation(book: Book.Galatians, chapter: 6, verse: 9))
        curatedVerses.append(VerseLocation(book: Book.Galatians, chapter: 6, verse: 10))
        curatedVerses.append(VerseLocation(book: Book.Matthew, chapter: 5, verse: 16))
        
        return curatedVerses
    }
    
    static func proclaimingSalvation() -> [VerseLocation] {
        var curatedVerses = [VerseLocation]()
        curatedVerses.append(VerseLocation(book: Book.Romans, chapter: 3, verse: 23))
        curatedVerses.append(VerseLocation(book: Book.Romans, chapter: 6, verse: 23))
        curatedVerses.append(VerseLocation(book: Book.Romans, chapter: 5, verse: 8))
        curatedVerses.append(VerseLocation(book: Book.Isaiah, chapter: 53, verse: 6))
        curatedVerses.append(VerseLocation(book: Book.Hebrews, chapter: 9, verse: 27))
        curatedVerses.append(VerseLocation(book: Book.Peter1, chapter: 3, verse: 18))
        curatedVerses.append(VerseLocation(book: Book.Ephesians, chapter: 2, verse: 8))
        curatedVerses.append(VerseLocation(book: Book.Ephesians, chapter: 2, verse: 9))
        curatedVerses.append(VerseLocation(book: Book.Titus, chapter: 3, verse: 5))
        curatedVerses.append(VerseLocation(book: Book.John, chapter: 1, verse: 12))
        curatedVerses.append(VerseLocation(book: Book.Revelation, chapter: 3, verse: 20))
        curatedVerses.append(VerseLocation(book: Book.John1, chapter: 5, verse: 13))
        curatedVerses.append(VerseLocation(book: Book.John, chapter: 5, verse: 24))

        
        return curatedVerses
    }
}

enum Book: String, Codable, CaseIterable {
    case Genesis, Exodus, Leviticus, Numbers, Deutoronomy, Joshua, Judges, Ruth, Samuel1, Samuel2, Kings1, Kings2, Chronicles1, Chronicles2, Ezra, Nehemiah, Esther, Job, Psalms, Proverbs, Ecclesiastes, SongOfSolomon, Isaiah, Jeremiah, Lamentations, Ezekiel, Daniel, Hosea, Joel, Amos, Obadadiah, Jonah, Micah, Nahum, Habakuk, Zephaniah, Haggai, Zechariah, Malachi, Matthew, Mark, Luke, John, Acts, Romans, Corinthians1, Corinthians2, Galatians, Ephesians, Philippians, Colossians, Thessalonians1, Thessalonians2, Timothy1, Timothy2, Titus, Philemon, Hebrews, James, Peter1, Peter2, John1, John2, John3, Jude, Revelation
    
    var displayName: String {
        if self.rawValue.hasSuffix("1") {
            return "1 \(self.rawValue.prefix(self.rawValue.count-1))"
        } else if self.rawValue.hasSuffix("2") {
            return "2 \(self.rawValue.prefix(self.rawValue.count-1))"
        } else if self.rawValue.hasSuffix("3") {
            return "3 \(self.rawValue.prefix(self.rawValue.count-1))"
        } else {
            return self.rawValue
        }
    }
}
