//
//  WordInVerse.swift
//  TextMemoriser
//
//  Created by David Cormell on 04/01/2021.
//

import Foundation

struct WordInVerse: Identifiable, Hashable {
    let id: Int
    let word: String
    
    init(id: Int, word: String) {
        self.id = id
        self.word = word
    }
}
