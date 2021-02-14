//
//  Reference.swift
//  TextMemoriser
//
//  Created by David Cormell on 03/01/2021.
//

import Foundation

struct Reference {
    let book: String
    let chapter: Int
    let verse: Int
    let text: String
    
    func display() -> String {
        return "\(book) \(chapter):\(verse)"
    }
}

class ReferenceFactory {
    static func makeReferences() -> [Reference] {
        var references = [Reference]()
        
        references.append(Reference(book: "Colossians", chapter: 3, verse: 16, text: "Let the word of Christ dwell in your richly, teaching and admonishing one another in all wisdom, singing psalms and hymns and spiritual songs, with thankfulness in your hearts to God."))
        
        references.append(Reference(book: "2 Timothy", chapter: 1, verse: 7, text: "for God gave us a spirit not of fear but of power and love and self-control"))
        
        references.append(Reference(book: "John", chapter: 3, verse: 16, text: "For God so loved the world..."))
        
        return references
    }
}
