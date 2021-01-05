//
//  WordInVerse.swift
//  TextMemoriser
//
//  Created by David Cormell on 04/01/2021.
//

import Foundation

class WordInVerse: Identifiable {
    let id: Int
    let word: String
    
    init(id: Int, word: String) {
        self.id = id
        self.word = word
    }
}
