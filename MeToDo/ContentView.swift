//
//  ContentView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/13.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @SceneStorage("selectedTab") var currentTab: Int = 0
    
    // MARK: - Body
    var body: some View {
            TabView(selection: $currentTab) {
                HomeView()
                    .tag(HomeView.homeTag)
                ProjectView(showClosedProjects: false)
                    .tag(ProjectView.openTag)
                Text("Add")
                    .tag(2)
                ProjectView(showClosedProjects: true)
                    .tag(ProjectView.closedTag)
                Text("Network")
                    .tag(4)
            }  //: TabView
            .onAppear(perform: {
                // with tab bar shown, it leaves tiny marks on background
                UITabBar.appearance().isHidden = true
            })
            .overlay(TabBarView(selectedTab: $currentTab), alignment: .bottom)
            .ignoresSafeArea()
    }  //: body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
