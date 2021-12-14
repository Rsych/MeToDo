//
//  HomeView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/13.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    static let homeTag: Int = 0
    @EnvironmentObject var dataController: DataController
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                Button("Add Data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
