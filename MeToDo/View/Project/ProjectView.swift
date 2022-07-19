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

    @State private var itemTitle = ""
    @State private var itemDetail = ""
    @State private var itemPriority = 2
    @State private var showAddItem = false
    @StateObject var viewModel: ViewModel

    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.projects) { project in
                    sections(project: project)
                }  //: Project loop
            }  //: List
            .padding(.bottom, 50)
            .listStyle(PlainListStyle())
            .navigationTitle(viewModel.showClosedProjects ? "Finished" : "Open")
            .toolbar {
                sortOrderToolbar
            } //: Toolbar
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
            } //: ConfirmationDialog
        }  //: NavView
    }  //: Body
    

    var sortOrderToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
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


extension ProjectView {
    @ViewBuilder func sections(project: Project) -> some View {
        Section {
            ForEach(project.projectItems(using: viewModel.sortOrder)) { item in
                ItemRowListView(project: project, item: item)
            } //: Project item list loop
            .onDelete { offsets in
                viewModel.delete(offsets, project: project)
            }  //: Delete Item

            if viewModel.showClosedProjects ==  false {
                Button {
                    withAnimation {
                        showAddItem.toggle()
                    }
                } label: {
                    Label("Add a task", systemImage: "plus")
                } //: Button
                .textFieldAlert(
                    isPresented: $showAddItem,
                    title: "Add a task".localized,
                    itemTitle: "",
                    itemTitlePlaceHolder: "Task name".localized,
                    itemDetail: "",
                    itemDetailPlaceHolder: "Description".localized,
                    action: {
                        itemTitle = $0?[0] ?? ""
                        itemDetail = $0?[1] ?? ""
                        viewModel.addItem(to: project, title: itemTitle, detail: itemDetail)
                    }
                )
            }  //: OpenTab
        } header: {
            ProjectHeaderView(project: project)
                .foregroundColor(.primary)
                .font(.title2)
        }  //: Section
        .padding([.top, .bottom], 5)
        .listRowSeparator(.hidden)
    }
}
