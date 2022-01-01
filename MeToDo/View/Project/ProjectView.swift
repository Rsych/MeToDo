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

    @StateObject var viewModel: ViewModel

    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.projects) { project in
                    Section {
                        ForEach(project.projectItems(using: viewModel.sortOrder)) { item in
                            ItemRowListView(project: project, item: item)
//                                .fixedSize(horizontal: false, vertical: true)
                        } //: Project item list loop
                        .onDelete { offsets in
                            viewModel.delete(offsets, project: project)
                        }  //: Delete Item

                        if viewModel.showClosedProjects ==  false {
                            Button {
                                withAnimation {
                                viewModel.addItem(to: project)
                                }
                            } label: {
                                Label("Add a task", systemImage: "plus")
                            }
                        }  //: OpenTab
                    } header: {
                        ProjectHeaderView(project: project)
                            .foregroundColor(.primary)
                            .font(.title2)
                    }  //: Section
                    .padding([.top, .bottom], 5)
                    .listRowSeparator(.hidden)
//                    .padding(.bottom, 3)
                }  //: Project loop
            }  //: List
            .listStyle(PlainListStyle())
            .navigationTitle(viewModel.showClosedProjects ? "Finished" : "Open")
            .toolbar {
                sortOrderToolbar
            } //: Toolbar
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Sort tasks", isPresented: $showingSheet, titleVisibility: .visible) {
                Button("Automatic") {
                    viewModel.sortOrder = .automatic
                }
                Button("Creation date") {
                    viewModel.sortOrder = .creationDate
                }
                Button("Title") {
                    viewModel.sortOrder = .title
                }
            }
        }  //: NavView
    }  //: Body

    var sortOrderToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSheet.toggle()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
                    .tint(.primary)
            }
        } //: ToolbarItem
    }  //: sortToolbar
    init(dataController: DataController, showClosedProjects: Bool) {
        let viewModel = ViewModel(dataController: dataController, showClosedProjects: showClosedProjects)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
} //: contentView

struct ProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ProjectView(dataController: DataController.preview, showClosedProjects: false)
        ProjectView(dataController: DataController.preview, showClosedProjects: true)
    }
}
