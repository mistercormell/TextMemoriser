//
//  EsvBibleAdaptor.swift
//  TextMemoriser
//
//  Created by David Cormell on 07/01/2021.
//

import Foundation


class EsvBibleAdaptor {
    func fetchVerseWithReference(location: VerseLocation, completion: @escaping (Passage) -> Void) {
        
        var urlComponents = URLComponents(string: "https://api.esv.org/v3/passage/text/")
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: "\(location.book.displayName)+\(location.chapter):\(location.verse)"),
            URLQueryItem(name: "include-short-copyright", value: "false"),
            URLQueryItem(name: "include-headings", value: "false"),
            URLQueryItem(name: "include-verse-numbers", value: "false"),
            URLQueryItem(name: "include-passage-references", value: "false"),
            URLQueryItem(name: "include-footnotes", value: "false")
        ]
        
        guard let url = urlComponents?.url else {
            print("Invalid url components url")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("81bd2bc0a1fca63b183de3ad73dd36753784fb6c", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(EsvBibleResponse.self, from: data) {
                    if let verseText = decodedResponse.passages.first {
                        let passage = Passage(location: location, text: verseText.trimmingCharacters(in: .whitespacesAndNewlines), copyright: "ESV")
                        completion(passage)
                    }

                }
            }

        }.resume()
    }
}
