//
//  LearningSetView.swift
//  TextMemoriser
//
//  Created by David Cormell on 13/02/2021.
//

import SwiftUI

struct LearningSetView: View {
    @EnvironmentObject var stateController: StateController
    var body: some View {
        NavigationView {
            List {
                ForEach(stateController.learningSet) { location in
                    Text(location.display)
                }
                .onDelete(perform: { indexSet in
                    stateController.learningSet.remove(atOffsets: indexSet)
                })
            }
            .toolbar {
                EditButton()
            }
            .navigationTitle("Learning Set")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct LearningSetView_Previews: PreviewProvider {
    static var previews: some View {
        LearningSetView()
    }
}
