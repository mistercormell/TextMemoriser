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
    case Genesis, Exodus, Leviticus, Numbers, Deuteronomy, Joshua, Judges, Ruth, Samuel1, Samuel2, Kings1, Kings2, Chronicles1, Chronicles2, Ezra, Nehemiah, Esther, Job, Psalms, Proverbs, Ecclesiastes, SongOfSolomon, Isaiah, Jeremiah, Lamentations, Ezekiel, Daniel, Hosea, Joel, Amos, Obadiah, Jonah, Micah, Nahum, Habakkuk, Zephaniah, Haggai, Zechariah, Malachi, Matthew, Mark, Luke, John, Acts, Romans, Corinthians1, Corinthians2, Galatians, Ephesians, Philippians, Colossians, Thessalonians1, Thessalonians2, Timothy1, Timothy2, Titus, Philemon, Hebrews, James, Peter1, Peter2, John1, John2, John3, Jude, Revelation
    
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
    
    var numberOfChapters: Int {
        switch self {
        case .Genesis: return 50
        case .Exodus: return 40
        case .Leviticus: return 27
        case .Numbers: return 36
        case .Deuteronomy: return 34
        case .Joshua: return 24
        case .Judges: return 21
        case .Ruth: return 4
        case .Samuel1: return 31
        case .Samuel2: return 24
        case .Kings1: return 22
        case .Kings2: return 25
        case .Chronicles1: return 29
        case .Chronicles2: return 36
        case .Ezra: return 10
        case .Nehemiah: return 13
        case .Esther: return 10
        case .Job: return 42
        case .Psalms: return 150
        case .Proverbs: return 31
        case .Ecclesiastes: return 12
        case .SongOfSolomon: return 8
        case .Isaiah: return 66
        case .Jeremiah: return 52
        case .Lamentations: return 5
        case .Ezekiel: return 48
        case .Daniel: return 12
        case .Hosea: return 14
        case .Joel: return 3
        case .Amos: return 9
        case .Obadiah: return 1
        case .Jonah: return 4
        case .Micah: return 7
        case .Nahum: return 3
        case .Habakkuk: return 3
        case .Zephaniah: return 3
        case .Haggai: return 2
        case .Zechariah: return 14
        case .Malachi: return 4
        case .Matthew: return 28
        case .Mark: return 16
        case .Luke: return 24
        case .John: return 21
        case .Acts: return 28
        case .Romans: return 16
        case .Corinthians1: return 16
        case .Corinthians2: return 13
        case .Galatians: return 6
        case .Ephesians: return 6
        case .Philippians: return 4
        case .Colossians: return 4
        case .Thessalonians1: return 5
        case .Thessalonians2: return 3
        case .Timothy1: return 6
        case .Timothy2: return 4
        case .Titus: return 3
        case .Philemon: return 1
        case .Hebrews: return 13
        case .James: return 5
        case .Peter1: return 5
        case .Peter2: return 3
        case .John1: return 5
        case .John2: return 1
        case .John3: return 1
        case .Jude: return 1
        case .Revelation: return 22
        }
    }
}
