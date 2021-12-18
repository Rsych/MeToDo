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
                            ItemRowListView(item: item)
                                .sheet(isPresented: $showModal) {
                                    EditItemView(item: item)
                                }
                                .onTapGesture {
                                    showModal = true
                                }

                        } //: Project item list loop
                        .onDelete { offsets in
                            let allItems = project.projectItems

                            for offset in offsets {
                                let item = allItems[offset]
                                dataController.delete(item)
                            }
                            dataController.save()
                        }  //: Delete Item

                        if showClosedProjects ==  false {
                            Button {
                                withAnimation {
                                    let item = Item(context: managedObjectContext)
                                    item.project = project
                                    item.creationDate = Date()
                                    dataController.save()
                                }
                            } label: {
                                Label("Add New item", systemImage: "plus")
                            }

                        }
                    } header: {
                        ProjectHeaderView(project: project)
                            .foregroundColor(.primary)
                            .font(.title2)
                    }
                    .padding(.bottom, 3)
                }
            }  //: List
            .listStyle(SidebarListStyle())
            .navigationTitle(showClosedProjects ? "Finished" : "Open")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSheet.toggle()
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                } //: ToolbarItem
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
}

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
