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

//    @State private var showingNotificationsError = false

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

                DueDateView(dueOn: $dueOn, dueDate: $dueDate)
                // Notification section
            }  //: Form
//            .alert(isPresented: $showingNotificationsError) {
//                Alert(
//                    title: Text("Oops!"),
//                    message: Text("There was a problem. Please check you have notifications enabled."),
//                    primaryButton: .default(Text("Check Settings"), action: dataController.showAppSettings),
//                    secondaryButton: .cancel()
//                )
//            }

            .navigationTitle("Add Project")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        save()
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
        if dueOn {
            project.dueDate = dueDate
            dataController.addDueDateReminder(for: project) { success in
                if success == false {
                    project.dueDate = nil
                    dueOn = false
//                    showingNotificationsError = true
                }
            }
        } else {
            project.dueDate = nil
            dataController.removeDueReminder(for: project)
        }
        dataController.save()
    }
}

struct AddProjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddProjectView()
    }
}
