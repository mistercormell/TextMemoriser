//
//  VerseLocation.swift
//  TextMemoriser
//
//  Created by David Cormell on 09/01/2021.
//

import Foundation

struct VerseLocation: Codable, Identifiable {
    let book: Book
    let chapter: Int
    let verse: Int
    
    var display: String {
        "\(book.displayName) \(chapter):\(verse)"
    }
    
    var id: String {
        display
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
