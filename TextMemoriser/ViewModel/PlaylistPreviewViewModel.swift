//
//  PlaylistPreviewViewModel.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 02/10/2025.
//

import Foundation

@Observable
class PlaylistPreviewViewModel {
    let title: String
    let translation: Translation
    let locations: [VerseLocation]
    let adaptor = BibleAdaptor()
    var passages: [Passage] = []
    
    init(title: String, translation: Translation, locations: [VerseLocation]) {
        self.title = title
        self.translation = translation
        self.locations = locations
    }
    
    func fetchReferences() {
        for location in locations {
            adaptor.fetchVerseWithReference(location: location, translation: translation, completion: { reference in
                DispatchQueue.main.async {
                    self.passages.append(reference)
                }
            })
        }
    }
    
}
