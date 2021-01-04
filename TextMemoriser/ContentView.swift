//
//  ContentView.swift
//  TextMemoriser
//
//  Created by David Cormell on 03/01/2021.
//

import SwiftUI

struct ContentView: View {
    let verses = ReferenceFactory.makeReferences()
    
    @State var verseIndex = 0
    
    var body: some View {
        VStack {
            Text(verses[verseIndex].text)
                .padding()
            Button("Next verse", action: {
                verseIndex = Int.random(in: 0..<verses.count)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
