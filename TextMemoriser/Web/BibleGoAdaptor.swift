//
//  BibleGoAdaptor.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 11/03/2024.
//

import Foundation

class BibleGoAdaptor {
    private func getVerseId(from verseLocation: VerseLocation) -> String {
        let bookId = getBookId(from: verseLocation.book)
        let chapterId = String(format: "%03d", verseLocation.chapter)
        let verseId = String(format: "%03d", verseLocation.verse)
        
        return "\(bookId)\(chapterId)\(verseId)"
    }
    
    private func getBookId(from book: Book) -> Int {
        //TODO - handle this more elegantly if it can't find the book
        return (Book.allCases.firstIndex(of: book) ?? 0) + 1
    }
    
    func fetchVerseWithReference(location: VerseLocation, translation: Translation, completion: @escaping (Passage) -> Void) {
        
        var urlComponents = URLComponents(string: "https://bible-go-api.rkeplin.com/v1/books/\(getBookId(from: location.book))/chapters/\(location.chapter)/\(getVerseId(from: location))")
        urlComponents?.queryItems = [
            URLQueryItem(name: "translation", value: "\(translation.details.shortName)"),
        ]
        
        guard let url = urlComponents?.url else {
            print("Invalid url components url")
            return
        }
        
        var request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(BibleGoResponse.self, from: data) {
                    let passage = Passage(location: location, text: decodedResponse.verse.trimmingCharacters(in: .whitespacesAndNewlines), copyright: "\(translation.details.shortName)")
                    completion(passage)
                }
            }

        }.resume()
    }
}
