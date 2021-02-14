//
//  VersePickerView.swift
//  TextMemoriser
//
//  Created by David Cormell on 13/02/2021.
//

import SwiftUI

struct VersePickerView: View {
    @State var bookChoice: Book
    @State var chapterChoice: Int
    @State var verseChoice: Int
    
    var body: some View {
        Form {
            Picker(selection: $bookChoice, label: Text("Book"), content: {
                ForEach(Book.allCases, id: \.self) {
                    Text($0.displayName)
                }
            })
            Picker(selection: $chapterChoice, label: Text("Chapter"), content: {
                ForEach(0 ... 150, id: \.self) {
                    Text("\($0)")
                }
            })
            Picker(selection: $verseChoice, label: Text("Verse"), content: {
                ForEach(0 ... 60, id: \.self) {
                    Text("\($0)")
                }
            })
        }
    }
}

struct VersePickerView_Previews: PreviewProvider {
    static var previews: some View {
        VersePickerView(bookChoice: Book.Genesis, chapterChoice: 1, verseChoice: 1)
    }
}
