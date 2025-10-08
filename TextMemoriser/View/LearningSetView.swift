//
//  LearningSetView.swift
//  TextMemoriser
//
//  Created by David Cormell on 13/02/2021.
//

import SwiftUI

struct LearningSetView: View {
    @EnvironmentObject var stateController: StateController
    @EnvironmentObject var progress: MemorisationProgress
    @State var showingAdd: Bool = false
    @State var globalScore: Int = 0
    @State var currentLevel: Int = 0
    @State var currentLevelName: String = ""
    @State var nextLevelName: String? = ""
    @State var progressFraction: Double = 0.0
    
    var body: some View {
        NavigationStack {
            VStack {
                ProgressView(value: progressFraction)
                    .progressViewStyle(LinearProgressViewStyle(tint: BrandStyle.primary))
                    .padding([.leading, .trailing])
                HStack {
                    Text("\(currentLevelName)")
                    Text("(\(globalScore))")
                        .fontWeight(.bold)
                    Spacer()
                    if let nextLevel = nextLevelName {
                        Text("Next Rank: \(nextLevel)")
                    }
                    
                }
                .padding([.leading, .trailing])
            }
            .padding()
            .onAppear {
                globalScore = progress.getGlobalScore()
                currentLevel = progress.getCurrentLevel(globalScore: globalScore)
                currentLevelName = progress.getCurrentLevelName(level: currentLevel)
                nextLevelName = progress.getNextLevelName(currentLevel: currentLevel)
                progressFraction = progress.getProgressFraction(currentLevel: currentLevel, globalScore: globalScore)
            }
            Group {
                if stateController.learningSet.count == 0 {
                    List {
                        Text("No verses in learning set. Add some verses using the Add button")
                    }
                } else {
                    List {
                        ForEach(stateController.learningSet) { location in
                            let mastery = progress.getMasteryScore(for: location)
                            NavigationLink {
                                LearnView(selectedVerse: location)
                            } label: {
                                HStack {
                                    HStack(spacing: 2) {
                                        ForEach(Array(scoreToStars(mastery).enumerated()), id: \.offset) { _, symbol in
                                            Image(systemName: symbol)
                                                .foregroundColor(BrandStyle.secondary)
                                        }
                                    }

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
    
    func scoreToStars(_ mastery: Double) -> [String] {
        // Map mastery (0–100) to fractional stars (0–3)
        let starFraction: Double = {
            switch mastery {
            case ..<30:
                return 0
            case 30..<60:
                return 0.5 + (mastery - 30) / 30 * 0.5
            case 60..<80:
                return 1.0 + (mastery - 60) / 20 * 1.5
            default:
                return 3
            }
        }()

        // Generate 3 star symbols
        return (0..<3).map { index in
            if Double(index + 1) <= starFraction {
                return "star.fill"                   // full star
            } else if Double(index) + 0.5 <= starFraction {
                return "star.leadinghalf.filled"    // half star
            } else {
                return "star"                        // empty star
            }
        }
    }
}

struct LearningSetView_Previews: PreviewProvider {
    static var previews: some View {
        LearningSetView()
            .environmentObject(StateController())
            .environmentObject(MemorisationProgress())
    }
}
