//
//  RootTabView.swift
//  TextMemoriser
//
//  Created by David Cormell on 31/01/2021.
//

import SwiftUI

struct RootTabView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var vm: StateController
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LearningSetView()
                .tabItem {
                    Image(systemName: "star")
                    Text("Goals")
                }
                .tag(0)
            PracticeView()
                .tabItem {
                    Image(systemName: "graduationcap")
                    Text("Practice")
                }
                .tag(1)
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(2)

        }
        .onAppear(perform: { vm.restoreUserSettings()
            vm.fetchReferences() })
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView()
    }
}
