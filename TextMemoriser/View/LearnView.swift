//
//  LearnView.swift
//  TextMemoriser
//
//  Created by David Cormell on 30/01/2021.
//

import SwiftUI
import AVFoundation

struct LearnView: View {
    @EnvironmentObject var vm: StateController
    var selectedVerse: VerseLocation
    
    
    var body: some View {
        Group {
            if let currentReference = vm.currentReference {
                Content(passageText: currentReference.text, passageLocation: currentReference.location.display, passageLocationWithCopyright: currentReference.displayLocationWithCopyright, passage: currentReference, passageTextOpacity: 1.0)
            } else {
                ProgressView("Loading verses...")
            }
        }
        .onAppear(perform: { vm.updateCurrentReference(location: selectedVerse) })
    }
}

extension LearnView {
    struct Content: View {
        let passageText: String
        let passageLocation: String
        let passageLocationWithCopyright: String
        let passage: Passage
        @State var passageTextOpacity = 1.0
        @State private var speechSynthesizer = AVSpeechSynthesizer()
        @StateObject private var speechRecogniser = SpeechRecognition()
        @State private var isMemorising = false
        @State private var verseComparison: VerseComparison?
        @State private var isShowingPracticeResult: Bool = false
        let speech = SpeechSynthesis()
        
        var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        speech.speak(text: "\(passageText):\(passageLocation)")
                    }, label: {
                        Image(systemName: "speaker.2")
                            .font(.largeTitle)
                            .padding()
                    })
                }
                Text("Tap to \(isVerseDisplayShown() ? "Hide" : "Reveal")")
                    .font(.caption2)
                    .animation(.easeInOut, value: passageTextOpacity)
                Text(passageText)
                    .padding()
                    .opacity(passageTextOpacity)
                    .border(.gray)
                    .contentShape(Rectangle())
                    .animation(.easeInOut, value: passageTextOpacity)
                    .onTapGesture {
                        toggleVerseDisplay()
                    }
                HStack {
                    Spacer()
                    Text(passageLocationWithCopyright)
                        .bold()
                        .padding()
                }
                Spacer()
                VStack {
                    ScrollView {
                        if !speechRecogniser.transcribedText.isEmpty {
                            Text(speechRecogniser.transcribedText)
                                .font(.body)
                                .foregroundColor(speechRecogniser.transcribedText.isEmpty ? .secondary : .primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.blue.opacity(0.05))
                                .cornerRadius(8)
                        }
                    }
                    .frame(height: 140)
                    .padding(.horizontal)
                    Button(action: {
                        if speechRecogniser.authorizationStatus == .authorized {
                            if speechRecogniser.isRecording {
                                speechRecogniser.stopRecording()
                                showVerseDisplay()
                                verseComparison = DictatedVerseChecker.compare(target: passage.text, spoken: speechRecogniser.transcribedText)
                                isShowingPracticeResult = true
                            } else {
                                speechRecogniser.startRecording()
                                hideVerseDisplay()
                            }
                        } else {
                            speechRecogniser.requestAuthorization()
                        }
                    }) {
                        HStack {
                            Image(systemName: speechRecogniser.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                                .font(.title2)
                            Text(speechRecogniser.isRecording ? "Stop Recording" : "Practice Out Loud")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(speechRecogniser.isRecording ? Color.red : Color.accentColor)
                    .padding(.horizontal)
                    .disabled(speechRecogniser.authorizationStatus != .authorized && speechRecogniser.authorizationStatus != .notDetermined)
                    
                }
                Button(action: {
                    isMemorising = true
                }) {
                    HStack {
                        Image(systemName: "book.circle.fill")
                            .font(.title2)
                        Text("Start Verse Lesson")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .tint(BrandStyle.secondary)
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .alert(isPresented: $isShowingPracticeResult, content: {
                Alert(title: Text("\(verseComparison?.isMatch ?? false ? "Perfect" : "Not quite!")"), message: Text("Accuracy: \(Int((verseComparison?.accuracy ?? 0) * 100))% \n\(verseComparison?.matchedWords ?? 0) of \(verseComparison?.totalWords ?? 0) words correct."), dismissButton: .default(Text("OK")) { isShowingPracticeResult = false } )})
            .fullScreenCover(isPresented: $isMemorising) {
                MemoriseView(passage: passage, isMemorising: $isMemorising)
            }
        }
        
        func toggleVerseDisplay() {
            isVerseDisplayShown() ? hideVerseDisplay() : showVerseDisplay()
        }
        
        func isVerseDisplayShown() -> Bool {
            return passageTextOpacity == 1.0
        }
        
        func showVerseDisplay() {
            passageTextOpacity = 1.0
        }
        
        func hideVerseDisplay() {
            passageTextOpacity = 0.0
        }

    }
    

}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LearnView.Content(passageText: Passage.example.text, passageLocation: Passage.example.location.display, passageLocationWithCopyright: Passage.example.displayLocationWithCopyright, passage: Passage.example, passageTextOpacity: 1.0)
        }
    }
}
