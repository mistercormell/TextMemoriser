//
//  LearningSetView.swift
//  TextMemoriser
//
//  Created by David Cormell on 13/02/2021.
//

import SwiftUI

struct LearningSetView: View {
    @EnvironmentObject var stateController: StateController
    @State var showingAdd: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(stateController.learningSet) { location in
                    Text(location.display)
                }
                .onDelete(perform: { indexSet in
                    stateController.removeVerseFromLearningSet(atOffset: indexSet)
                })
            }
            .navigationBarItems(leading: Button(action: {
                self.showingAdd = true
            }) {
                Text("Add")
            }, trailing: EditButton())
            .navigationTitle("Learning Set")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingAdd, content: {
            NavigationView {
                AddLearningGoalView()
                    .navigationTitle("Add Verse")
                    .navigationBarTitleDisplayMode(.inline)
            }
        })
    }
}

struct LearningSetView_Previews: PreviewProvider {
    static var previews: some View {
        LearningSetView()
    }
}
