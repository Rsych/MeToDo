//
//  HomeView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/13.
//

import SwiftUI
import CoreData

struct HomeView: View {
    // MARK: - Properties
    static let homeTag: Int = 0
    @EnvironmentObject var dataController: DataController
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)],
        predicate: NSPredicate(format: "closed = false")) var projects: FetchedResults<Project>

    
    let items: FetchRequest<Item>
    
    init() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "completed = false")
        
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Item.priority, ascending: false)
        ]
        request.fetchLimit = 10
        
        items = FetchRequest(fetchRequest: request)
    }
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                Button("Add Data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }
            }  //: ScrollView
            .navigationTitle("Home")
        }  //: NavView
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
