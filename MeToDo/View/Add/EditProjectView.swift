//
//  EditProjectView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/15.
//

import SwiftUI

struct EditProjectView: View {
    // MARK: - Properties
    let project: Project

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @Binding var showModal: Bool

    @State private var showingDeleteConfirm = false

    @State private var title: String
    @State private var detail: String
    @State private var color: String

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))]

//    init(project: Project, showModal: Binding<Bool>) {
    init(project: Project) {
        self.project = project
//        _showModal = showModal

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)
    }
    // MARK: - Body
    var body: some View {
        NavigationView {
        Form {
            Section {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            } header: {
                Text("Basic settings")
            } // section 1

            Section {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }  //: LazyVGrid
                .padding(.vertical)
            } header: {
                Text("Choose project color")
            } // section 2

            Section {
                Button(project.closed ? "Reopen project" : "Finish this project") {
                    project.closed.toggle()
                    update()
//                    showModal.toggle()
                    presentationMode.wrappedValue.dismiss()
                }
                Button("Delete this project") {
                    showingDeleteConfirm.toggle()
                }
                .foregroundColor(.red)
            } footer: {
                Text("Closing")
            } // section 3

        }  //: Form
        .navigationTitle("Edit Project")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Dismiss") {
//                    self.showModal.toggle()
                    presentationMode.wrappedValue.dismiss()
                } //: Button
            } //: ToolbarItem
        } //: Toolbar
        }
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(
                title: Text("Delete project?"),
                message: Text("Are you sure you want to delete this project? You will lose all the items inside."),
                primaryButton: .default(Text("Delete"), action: delete),
                secondaryButton: .cancel()
            )
        }
    }  //: body

    func update() {
        project.title = title
        project.detail = detail
        project.color = color
    }

    func delete() {
        dataController.delete(project)
        self.presentationMode.wrappedValue.dismiss()
    }

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)
            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }  //: ZStack
        .onTapGesture {
            color = item
            update()
        }
    }
}

// struct EditProjectView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProjectView(project: Project.example, showModal: .constant(true))
//    }
// }
