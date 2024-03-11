//
//  BibleGoResponse.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 11/03/2024.
//

import Foundation

struct BibleGoResponse: Decodable {
    var id: Int
    var book: BibleGoBookResponse
    var chapterId: Int
    var verseId: Int
    var verse: String
}

struct BibleGoBookResponse: Decodable {
    var id: Int
    var name: String
    var testament: String
}
