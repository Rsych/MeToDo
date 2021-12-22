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

    @State private var selectedItem: FetchedResults<Item>.Element?
    @State private var selectedProject: FetchedResults<Project>.Element?
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
                                Button {
                                    self.selectedProject = project
                                } label: {
                                VStack(alignment: .leading) {
                                    Text("\(project.projectItems.count) items")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    // Add ProjectInfoView later
                                    Text(project.projectTitle)
                                        .font(.title2)
                                        .foregroundColor(.primary)

                                    ProgressView(value: project.completionAmount)
                                        .tint(Color(project.projectColor))
                                }  //: VStack
                                .padding()
                                .background(.thickMaterial)
                                .cornerRadius(10)
                                .shadow(color: .primary.opacity(0.2), radius: 3)
                                }
                            }  //: project Loop
                        }  //: LazyHGrid
                        .padding([.top, .horizontal])
                        .fixedSize(horizontal: false, vertical: true)
                    }  //: ScrollView
                    .sheet(item: $selectedProject) {
                        EditProjectView(project: $0)
                    }

                    VStack(alignment: .leading) {
                        list("Up next", for: items.wrappedValue.prefix(3))
                        list("More to explore", for: items.wrappedValue.dropFirst(3))
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
    }

    @ViewBuilder func list(_ title: LocalizedStringKey, for items: FetchedResults<Item>.SubSequence) -> some View {
        if items.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)

            ForEach(items) { item in
//                NavigationLink(destination: EditItemView(item: item)) {
                    HStack(spacing: 20) {
                        Button {
                            //
                            self.selectedItem = item
                        } label: {
                            Circle()
                                .stroke(Color(item.project?.projectColor ?? "Orange"), lineWidth: 3)
                                .frame(width: 44, height: 44)
                            VStack(alignment: .leading) {
                                Text(item.itemTitle)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title2)
                                    .foregroundColor(Color(item.project?.projectColor ?? "Orange"))
                                Text(item.project!.projectTitle)
                                    .font(.caption)
                                    .foregroundColor(Color(item.project?.projectColor ?? "Orange"))
                                if item.itemDetail.isEmpty == false {
                                    Text(item.itemDetail)
                                        .foregroundColor(.secondary)
                                }
                            }  //: VStack
                        }  //: ButtonView
                    }  //: HStack
                    .padding()
                    .background(.thickMaterial)
                    .cornerRadius(10)
                    .shadow(color: .primary.opacity(0.2), radius: 2)
                    .sheet(item: $selectedItem) {
                        EditItemView(item: $0)
                    }
//                    .onTapGesture {
//                        showModal.toggle()
//                    }
//                }  //: NavLink
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
