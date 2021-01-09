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
        if viewModel.questionType == .guessLocation {
            GuessLocationView()
        } else {
            VerseArrangeView()
        }
    }
}

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeView()
    }
}
