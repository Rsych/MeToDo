//
//  ContentView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/13.
//

import SwiftUI
import CoreSpotlight

struct ContentView: View {
    // MARK: - Properties
    @SceneStorage("selectedTab") var currentTab: Int = 0
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("systemThemeEnabled") private var systemThemeEnabled = true
    @EnvironmentObject var dataController: DataController
    @State var shouldShowModel = false
    
    @EnvironmentObject private var appLockVM: AppLockViewModel
    
    @State private var selectedItem: FetchedResults<Item>.Element?
    
    @State var blurRadius: CGFloat = 0
    
    // MARK: - Body
    var body: some View {
        ZStack() {
            if !appLockVM.isAppLockEnabled || appLockVM.isAppUnLocked {
                TabView(selection: $currentTab) {
                    HomeView(dataController: dataController)
                        .tag(HomeView.homeTag)
                    ProjectView(dataController: dataController, showClosedProjects: false)
                        .tag(ProjectView.openTag)
                    EmptyView()
                    ProjectView(dataController: dataController, showClosedProjects: true)
                        .tag(ProjectView.closedTag)
                    MoreView()
                        .tag(MoreView.moreTag)
                    
                }  //: TabView
                // omg so easy fix...
                // NavBar missing fix
                .padding(.top)
                .navigationViewStyle(StackNavigationViewStyle())
                .onAppear(perform: {
                    // with tab bar shown, it leaves tiny marks on background
                    UITabBar.appearance().isHidden = true
                })
                .safeAreaInset(edge: .bottom, content: {
                    TabBarView(selectedTab: $currentTab)
                })
                //                .padding(.bottom, 50)
                //                .overlay(TabBarView(selectedTab: $currentTab), alignment: .bottom)
                .ignoresSafeArea(edges: .bottom)
            } else {
                LockedView()
            }
        } //: ZStack
        
        .onAppear {
            // if 'isAppLockEnabled' value true, then immediately do the app lock validation
            if appLockVM.isAppLockEnabled {
                appLockVM.appLockValidation()
            }
        }
        
        .onOpenURL(perform: openURL)

        //                    .padding(.bottom, 50) // commented with using .safeAreaInset
        .onChange(of: currentTab, perform: { _ in
            if currentTab == 2 {
                shouldShowModel = true
                currentTab = 0
            }
        })  //: AddProjectSheet
        .sheet(isPresented: $shouldShowModel, onDismiss: {
            currentTab = 0
        }, content: {
            AddProjectView()
                .blur(radius: !appLockVM.isAppLockEnabled || appLockVM.isAppUnLocked ? 0 : 5)

        })
        
        .onContinueUserActivity(CSSearchableItemActionType, perform: moveToHome)
        .sheet(item: $selectedItem) { item in
            EditItemView(item: item)
                .blur(radius: !appLockVM.isAppLockEnabled || appLockVM.isAppUnLocked ? 0 : 5)
        }
    }  //: body
    
    func moveToHome(_ input: Any) {
        currentTab = HomeView.homeTag
    }
    
    func openURL(_ url: URL) {
        print("url is \(url)")
        if url == URL(string: "metodo://newTodo") {
            shouldShowModel = true

        } else {
                self.selectedItem = dataController.urlItem(with: url)
            }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
