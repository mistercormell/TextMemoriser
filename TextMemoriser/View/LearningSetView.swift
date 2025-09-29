//
//  LearningSetView.swift
//  TextMemoriser
//
//  Created by David Cormell on 13/02/2021.
//

import SwiftUI

struct LearningSetView: View {
    @EnvironmentObject var stateController: StateController
    @Environment(MemorisationProgress.self) private var progress: MemorisationProgress
    @State var showingAdd: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if stateController.learningSet.count == 0 {
                    Text("No verses in learning set. Add some verses using the Add button")
                        .padding()
                } else {
                    List {
                        ForEach(stateController.learningSet) { location in
                            let mastery = progress.getMasteryScore(for: location)
                            NavigationLink {
                                LearnView(selectedVerse: location)
                            } label: {
                                HStack {
                                    Circle()
                                        .fill(
                                            Color(
                                                hue: scoreToHue(mastery),
                                                saturation: 0.8,
                                                brightness: 0.9
                                            )
                                        )
                                        .frame(width: 16, height: 16)

                                    Text(location.display)
                                }
                            }
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
            NavigationStack {
                AddLearningGoalView()
                    .navigationBarTitle("Add Verse")
                    .navigationBarTitleDisplayMode(.inline)
            }
        })
    }
    
    private func scoreToHue(_ score: Double) -> Double {
        let clamped = max(0, min(100, score))
        
        if clamped < 80 {
            // 0 → 80 maps to red → orange
            // Hue: red (0.0) → orange (approx 0.08)
            return (clamped / 80) * 0.08
        } else {
            // 80 → 100 maps to orange → green
            // Hue: orange (0.08) → green (0.33)
            return 0.08 + ((clamped - 80) / 20) * (0.33 - 0.08)
        }
    }
}

struct LearningSetView_Previews: PreviewProvider {
    static var previews: some View {
        LearningSetView()
    }
}
