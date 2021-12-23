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

    @State private var showModal = false

    @EnvironmentObject var dataController: DataController
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)],
        predicate: NSPredicate(format: "closed = false")) var projects: FetchedResults<Project>

    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    let items: FetchRequest<Item>

    init() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()

        let completedPredicate = NSPredicate(format: "completed = false")
        let openPredicate = NSPredicate(format: "project.closed = false")
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])

        request.predicate = compoundPredicate
        request.predicate = NSPredicate(format: "completed = false AND project.closed = false")

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
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(projects) { project in
                                ProjectSummaryView(project: project)
                            }  //: project Loop
                        }  //: LazyHGrid
                        .padding([.top, .horizontal])
                        .fixedSize(horizontal: false, vertical: true)
                    }  //: ScrollView
                    VStack(alignment: .leading) {
                        HomeItemListView(title: "Up next", items: items.wrappedValue.prefix(3))
                        HomeItemListView(title: "More to explore", items: items.wrappedValue.dropFirst(3))
                    }
                    .padding(.horizontal)
                }  //: VStack
            }  //: ScrollView
            .navigationTitle("Home")
//            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Data Debug") {
                        dataController.deleteAll()
                        try? dataController.createSampleData()
                    }
                }
            }  //: toolbar
        }  //: NavView
    }  //: body
}  //: view

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
