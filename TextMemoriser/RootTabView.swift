//
//  RootTabView.swift
//  TextMemoriser
//
//  Created by David Cormell on 31/01/2021.
//

import SwiftUI

struct RootTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LearnView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Learn")
                }
                .tag(0)
            PracticeView()
                .tabItem {
                    Image(systemName: "graduationcap")
                    Text("Practice")
                }
                .tag(1)
            LearningSetView()
                .tabItem {
                    Image(systemName: "star")
                    Text("Goals")
                }
                .tag(2)
        }
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView()
    }
}
