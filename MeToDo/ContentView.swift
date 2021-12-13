//
//  ContentView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/13.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @State private var selectedTab = 0
    
    // MARK: - Body
    var body: some View {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                Text("Open")
                    .tag(1)
                Text("Add")
                    .tag(2)
                Text("Finished")
                    .tag(3)
                Text("Network")
                    .tag(4)
            }  //: TabView
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .overlay(TabBarView(selectedTab: $selectedTab), alignment: .bottom)
//            .padding(.bottom, 10)
            .ignoresSafeArea()

    }  //: body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
