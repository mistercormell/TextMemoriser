//
//  PracticeView.swift
//  TextMemoriser
//
//  Created by David Cormell on 09/01/2021.
//

import SwiftUI

struct PracticeView: View {
    @EnvironmentObject var viewModel: StateController
    
    var body: some View {
        if viewModel.learningSet.count != 0 {
            if viewModel.questionType == .missingWord {
                GuessMissingWordView()
            } else if viewModel.questionType == .guessLocation {
                GuessLocationView()
            } else {
                VerseArrangeView()
            }
        } else {
            Text("Please add verses to your learning set to start practicing!")
        }
    }
}

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeView()
    }
}
