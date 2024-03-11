//
//  BibleAdaptor.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 11/03/2024.
//

import Foundation

class BibleAdaptor {
    let esvBibleAdaptor = EsvBibleAdaptor()
    let bibleGoAdaptor = BibleGoAdaptor()
    
    func fetchVerseWithReference(location: VerseLocation, translation: Translation, completion: @escaping (Passage) -> Void) {
        if translation == .esv {
            esvBibleAdaptor.fetchVerseWithReference(location: location, completion: completion)
        } else {
            bibleGoAdaptor.fetchVerseWithReference(location: location, translation: translation, completion: completion)
        }
    }
}
