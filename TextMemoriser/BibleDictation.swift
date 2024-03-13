//
//  BibleDictation.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 13/03/2024.
//

import Foundation
import AVFoundation

class BibleDictation {
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func playVerseAndLocation(verse: String, location: String) {
        let utterance = AVSpeechUtterance(string: getVerseAndLocation(verse, location))
        utterance.rate = 0.5
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        
        speechSynthesizer.speak(utterance)
    }
    
    private func getVerseAndLocation(_ verse: String, _ location: String) -> String {
        return "\(verse) \(location)"
    }
}
