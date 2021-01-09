//
//  VerseLocation.swift
//  TextMemoriser
//
//  Created by David Cormell on 09/01/2021.
//

import Foundation

struct VerseLocation {
    let book: String
    let chapter: Int
    let verse: Int
}

enum Book: String, CaseIterable {
    case Genesis, Exodus, Leviticus, Numbers, Deutoronomy, Matthew, Mark, Luke, John, Acts, Romans, Timothy2
    
    var displayName: String {
        switch self {
        case .Timothy2:
            return "2Timothy"
        default:
            return self.rawValue
        }
    }
}
