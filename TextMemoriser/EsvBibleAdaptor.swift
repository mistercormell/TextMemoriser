//
//  EsvBibleAdaptor.swift
//  TextMemoriser
//
//  Created by David Cormell on 07/01/2021.
//

import Foundation


class EsvBibleAdaptor {
    func fetchVerseWithReference(book: String, chapter: Int, verse: Int, completion: @escaping (Reference) -> Void) {
        guard let url = URL(string: "https://api.esv.org/v3/passage/text/?q=\(book)+\(chapter):\(verse)&include-short-copyright=false&include-headings=false&include-verse-numbers=false&include-passage-references=false") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("81bd2bc0a1fca63b183de3ad73dd36753784fb6c", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(EsvBibleResponse.self, from: data) {
                    if let verseText = decodedResponse.passages.first {
                        let reference = Reference(book: book, chapter: chapter, verse: verse, text: verseText)
                        completion(reference)
                    }

                }
            }

        }.resume()
    }
}
