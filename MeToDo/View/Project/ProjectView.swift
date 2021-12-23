//
//  ProjectView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/14.
//

import UIKit
import SwiftUI

struct ProjectView: View {
    // MARK: - Properties
    static let openTag: Int = 1
    static let closedTag: Int = 3

    @State private var showModal = false
    @State private var showingSheet = false
    @State private var sortOrder = Item.SortOrder.automatic
    @State private var sortColorID = 1

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    let showClosedProjects: Bool
    let projects: FetchRequest<Project>

    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects

        projects = FetchRequest<Project>(
            entity: Project.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)],
            predicate: NSPredicate(format: "closed = %d", showClosedProjects),
            animation: .default
        )
    }

    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                ForEach(projects.wrappedValue) { project in
                    Section {
                        ForEach(project.projectItems(using: sortOrder)) { item in
                            ItemRowListView(project: project, item: item)
                        } //: Project item list loop
                        .onDelete { offsets in
                            delete(offsets, project: project)
                        }  //: Delete Item

                        if showClosedProjects ==  false {
                            Button {
                                addItem(to: project)
                            } label: {
                                Label("Add New item", systemImage: "plus")
                            }
                        }  //: OpenTab
                    } header: {
                        ProjectHeaderView(project: project)
                            .foregroundColor(.primary)
                            .font(.title2)
                    }  //: Section
                    .padding(.bottom, 3)
                }  //: Project loop
            }  //: List
            .listStyle(SidebarListStyle())
            .navigationTitle(showClosedProjects ? "Finished" : "Open")
            .toolbar {
                sortOrderToolbar
            } //: Toolbar
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Sort items", isPresented: $showingSheet, titleVisibility: .visible) {
                Button("Automatic") {
                    sortOrder = .automatic
                }
                Button("Creation date") {
                    sortOrder = .creationDate
                }
                Button("Title") {
                    sortOrder = .title
                }
            }
        }  //: NavView
    }  //: Body
    func addItem(to project: Project) {
        withAnimation {
            let item = Item(context: managedObjectContext)
            item.project = project
            item.creationDate = Date()
            dataController.save()
        }
    }  //: addItem
    func delete(_ offsets: IndexSet, project: Project) {
        let allItems = project.projectItems(using: sortOrder)

        for offset in offsets {
            let item = allItems[offset]
            dataController.delete(item)
        }
        dataController.save()
    }  //: delete
    var sortOrderToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSheet.toggle()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        } //: ToolbarItem
    }  //: sortToolbar
} //: contentView

struct ProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ProjectView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
        ProjectView(showClosedProjects: true)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
