//
//  AddProjectView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/17.
//

import SwiftUI

struct AddProjectView: View {
    // MARK: - Properties
    static let addTag: Int = 1
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String = ""
    @State private var detail: String = ""
    @State private var color: String = Project.colors.randomElement() ?? "Light Blue"
    @State private var dueOn: Bool = false
    @State private var dueDate: Date = Date()

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))]

    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                ProjectInfoView(title: $title, detail: $detail)

                ProjectColorButtonView(color: $color)

                DueDateView(dueOn: $dueOn, dueDate: $dueDate)

            }  //: Form
            .background(Color(uiColor: .systemBackground))
                        .listRowBackground(Color.clear)

                        .onAppear(perform: {
                            UITableView.appearance().backgroundColor = UIColor.clear
                            UITableViewCell.appearance().backgroundColor = UIColor.clear
                        })
            .resignKeyboardOnDragGesture()

            .navigationTitle("New Todo")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Dismiss") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        save()
                        self.presentationMode.wrappedValue.dismiss()
                    }  //: Dismiss Button
                    .disabled(title.isEmpty)
                }
            }  //: Dismiss Toolbar
        }  //: NavVIew
    }  //: body
    func save() {
        let project = Project(context: managedObjectContext)
        project.title = title
        project.detail = detail
        project.color = color
        project.closed = false
        project.creationDate = Date()
        if dueOn {
            project.dueDate = dueDate
            dataController.addDueDateReminder(for: project) { success in
                if success == false {
                    project.dueDate = nil
                    dueOn = false
                }
            }
        } else {
            project.dueDate = nil
            dataController.removeDueReminder(for: project)

        }
        dataController.uploadToiCloud(project)
        dataController.save()
    }
}

struct AddProjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddProjectView()
    }
}
