//
//  QuestionFeedback.swift
//  TextMemoriser
//
//  Created by David Cormell on 27/01/2022.
//

import Foundation

class QuestionFeedback: ObservableObject {
    @Published var alertTitle = ""
    @Published var alertBody = ""
    @Published var isShowing = false
}
