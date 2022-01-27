//
//  QuestionFeedbackView.swift
//  TextMemoriser
//
//  Created by David Cormell on 27/01/2022.
//

import SwiftUI

struct QuestionFeedbackView: View {
    @ObservedObject var questionFeedback: QuestionFeedback
    @EnvironmentObject var vm: StateController
    
    var body: some View {
        Alert(title: Text("\(questionFeedback.alertTitle)"), message: Text("\(questionFeedback.alertBody)\n\nYour score is: \(vm.score)"), dismissButton: .default(Text("OK")) {vm.nextQuestion()} )})
    }
}

struct QuestionFeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionFeedbackView()
    }
}
