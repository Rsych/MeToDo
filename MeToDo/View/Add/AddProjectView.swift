//
//  AddProjectView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/17.
//

import SwiftUI

struct AddProjectView: View {
    // MARK: - Properties
    //    let project: Project
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
                Section(content: {
                    TextField("Project Name", text: $title)
                    TextField("Description", text: $detail)
                }, header: {
                    Text("Basic settings")
                })  //: Section 1

                Section {
                    LazyVGrid(columns: colorColumns) {
                        ForEach(Project.colors, id: \.self) { item in
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
                            }
                        }  //: Color loop
                    }  //: LazyVGrid
                    .padding(.vertical)
                } header: {
                    Text("Choose project color")
                } // section 2

                Section {
                    Toggle("Add due date", isOn: $dueOn.animation())
                    if dueOn {
                        DatePicker("Pick a date", selection: $dueDate, displayedComponents: .date)
                    }
                } header: {
                    Text("Due date")
                }
            Section(content: {
                Button("Save") {
                    save()
                    self.presentationMode.wrappedValue.dismiss()
                }
            }, footer: {
                Text("Closing")
            })
            }  //: Form

            .navigationTitle("Add Project")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        self.presentationMode.wrappedValue.dismiss()
                    }  //: Dismiss Button
                }
            }  //: Dismiss Toolbar
        }  //: NavVIew
        //        .onAppear {
        //            let project = Project(context: managedObjectContext)
        //                            project.closed = false
        //            project.title = "Test"
        //                            project.creationDate = Date()
        //                            dataController.save()
        //        }
    }  //: body

    func save() {
        let project = Project(context: managedObjectContext)
        project.title = title
        project.detail = detail
        project.color = color
        project.closed = false
        project.creationDate = Date()
        project.dueDate = dueDate
        dataController.save()
    }
}

struct AddProjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddProjectView()
    }
}
