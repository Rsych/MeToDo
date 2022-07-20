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
    @State private var currentProject: Project = .example
    @StateObject var viewModel: ViewModel

    // MARK: - Body
    var body: some View {
        ZStack {
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
            }
        .navigationBarHidden(true)
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
            .disabled(showAddItem)
            .blur(radius: showAddItem ? 30 : 0)
            if showAddItem {
                addItemAlert(project: currentProject, message: "Add a task".localized)
            }
        }  //: ZStack
    }  //: Body
    
    func clearTextFields() {
        itemTitle.removeAll()
        itemDetail.removeAll()
        itemPriority = 2
    }
    
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
    // MARK: - Item Row Section
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
                        currentProject = project
                        showAddItem.toggle()
                    }
                } label: {
                    Label("Add a task", systemImage: "plus")
                } //: Button
            }  //: OpenTab
        } header: {
            ProjectHeaderView(project: project)
                .foregroundColor(.primary)
                .font(.title2)
        }  //: Section
//        .padding([.top, .bottom], 5)
        .listRowSeparator(.hidden)
    }
    // MARK: - Add Item
    @ViewBuilder func addItemAlert(project: Project, message: String) -> some View {
        VStack {
            Spacer()
            Text(message)
            Spacer()
            Group {
                TextField("Task name".localized, text: $itemTitle)
                TextField("Description".localized, text: $itemDetail)
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.darkGray))
            
            .padding([.leading, .trailing])
            Spacer()
            Picker("Priority".localized, selection: $itemPriority) {
                Text("Low").tag(1)
                Text("Medium").tag(2)
                Text("High").tag(3)
            }
            .padding([.leading, .trailing])
            .pickerStyle(.segmented)
            Spacer()
            Divider()
            HStack {
                Button {
                    showAddItem.toggle()
                    clearTextFields()
                } label: {
                    Text("Close".localized)
                }
                .frame(width: UIScreen.main.bounds.width/2 - 30, height: 44)
                .foregroundColor(.white)
                Button {
                    viewModel.addItem(to: project, title: itemTitle, detail: itemDetail, priority: itemPriority)
                    showAddItem.toggle()
                    clearTextFields()
                } label: {
                    Text("Ok".localized)
                }.disabled(itemTitle.isEmpty)
                .frame(width: UIScreen.main.bounds.width/2 - 30, height: 44)
                .foregroundColor(itemTitle.isEmpty ? .gray : .white)
            }
            .padding(.bottom, 4)
        }
        .frame(width: UIScreen.main.bounds.width - 50, height: 240)
        .background(Color.midnight.opacity(0.5))
        .cornerRadius(12)
        .clipped()
    }
}
