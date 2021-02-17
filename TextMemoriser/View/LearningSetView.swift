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
            Group {
                if stateController.learningSet.count == 0 {
                    Text("No verses in learning set. Add some verses using the Add button")
                        .padding()
                } else {
                    List {
                        ForEach(stateController.learningSet) { location in
                            Text(location.display)
                        }
                        .onDelete(perform: { indexSet in
                            stateController.removeVerseFromLearningSet(atOffset: indexSet)
                        })
                    }
                }
            }
            .navigationBarItems(leading: Button(action: {
                self.showingAdd = true
            }) {
                Text("Add")
            }, trailing: EditButton())
            .navigationBarTitle("Learning Set")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingAdd, content: {
            NavigationView {
                AddLearningGoalView()
                    .navigationBarTitle("Add Verse")
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
