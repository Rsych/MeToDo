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

    @State var shouldShowModel = false

    // MARK: - Body
    var body: some View {
            TabView(selection: $currentTab) {
                HomeView()
                    .tag(HomeView.homeTag)
                ProjectView(showClosedProjects: false)
                    .tag(ProjectView.openTag)
                EmptyView()
                ProjectView(showClosedProjects: true)
                    .tag(ProjectView.closedTag)
                Text("Network")
                    .tag(4)
            }  //: TabView
            .onChange(of: currentTab, perform: { _ in
                if currentTab == 2 {
                    shouldShowModel = true
                    currentTab = 0
                }
            })  //: AddProjectSheet
            .sheet(isPresented: $shouldShowModel, onDismiss: {
                currentTab = 1
            }, content: {
                AddProjectView()
            })
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
