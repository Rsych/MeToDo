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
    @EnvironmentObject var dataController: DataController
    @State var shouldShowModel = false

    // MARK: - Body
    var body: some View {
            TabView(selection: $currentTab) {
                HomeView(dataController: dataController)
                    .tag(HomeView.homeTag)
                ProjectView(dataController: dataController, showClosedProjects: false)
                    .tag(ProjectView.openTag)
                EmptyView()
                ProjectView(dataController: dataController, showClosedProjects: true)
                    .tag(ProjectView.closedTag)
                AwardsView()
                    .tag(AwardsView.awardsTag)
            }  //: TabView
            .padding(.bottom, 50)
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
