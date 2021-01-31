//
//  LearnView.swift
//  TextMemoriser
//
//  Created by David Cormell on 30/01/2021.
//

import SwiftUI

struct LearnView: View {
    var body: some View {
        NavigationView {
            Content(passageText: "placeholder verse text, blah, blah blah, blah, blah, need to get some more items.", passageLocation: "Genesis 3:16", next: nextPassage)
                .navigationBarTitle("Learn the Verse")
        }
    }
    
    func nextPassage() {
        print("next passage")
    }
}

extension LearnView {
    struct Content: View {
        let passageText: String
        let passageLocation: String
        let next: () -> Void
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(passageText)
                    .padding()
                Text(passageLocation)
                    .padding()
                
                Spacer()
                Button("Next", action: next)
                    .padding()
                    .alignmentGuide(.trailing) { d in d[.trailing]}
                
            }
        }
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
    }
}
