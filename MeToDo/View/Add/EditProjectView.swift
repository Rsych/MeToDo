//
//  EditProjectView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/15.
//
// swiftlint:disable line_length

import SwiftUI
import CloudKit

struct EditProjectView: View {
    // MARK: - Properties
    @ObservedObject var project: Project

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var showingDeleteConfirm = false
    //    @State private var showingNotificationsError = false

    @State private var title: String
    @State private var detail: String
    @State private var color: String

    @State private var dueOn: Bool
    @State private var dueDate: Date

    init(project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)

        if let projectRemindTime = project.dueDate {
            _dueDate = State(wrappedValue: projectRemindTime)
            _dueOn = State(wrappedValue: true)
        } else {
            _dueDate = State(wrappedValue: Date())
            _dueOn = State(wrappedValue: false)
        }
    }
    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                ProjectInfoView(title: $title.onChange(update), detail: $detail.onChange(update))

                ProjectColorButtonView(color: $color.onChange(update))

                DueDateView(dueOn: $dueOn, dueDate: $dueDate)

                Section {
                    Button(project.closed ? "Reopen project" : "Finish this project") {
                        project.closed.toggle()
                        update()
                        //                    showModal.toggle()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.blue)

                    // There's an error that notification terminates immediately after showing Alert
                    // Fix this later
                    //                .alert(isPresented: $showingNotificationsError) {
                    //                    Alert(
                    //                        title: Text("Oops!"),
                    //                        message: Text("There was a problem. Please check you have notifications enabled."),
                    //                        primaryButton: .default(Text("Check Settings"), action: showAppSettings),
                    //                        secondaryButton: .cancel()
                    //                    )
                    //                }
                    Button("Delete this project") {
                        print("Delete")
                        showingDeleteConfirm.toggle()
                    }
                    .foregroundColor(.red)
                    .alert(isPresented: $showingDeleteConfirm) {
                        Alert(
                            title: Text("Delete project?"),
                            message: Text("Are you sure you want to delete this project? You will lose all the items inside."),
                            primaryButton: .destructive(Text("Delete"), action: delete),
                            secondaryButton: .cancel()
                        )
                    }  //: Delete Alert
                } footer: {
                    Text("Closing")
                } // section 3
            }  //: Form
            .font(.body)
            .resignKeyboardOnDragGesture()

            .navigationTitle("Edit Project")
            .font(.title2)

//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                Button {
//                    dataController.uploadToiCloud(project)
//                } label: {
//                    Label("Upload to iCloud", systemImage: "icloud.and.arrow.up")
//                }
//                }
//            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        //                    self.showModal.toggle()
                        update()
                        dataController.uploadToiCloud(project)
                        presentationMode.wrappedValue.dismiss()
                    } //: Button
                    .disabled(title.isEmpty)
                    .foregroundColor(title.isEmpty ? .secondary : .blue)
                } //: ToolbarItem
            } //: Toolbar
            .font(.body)
        }  //: NavView
        .onDisappear(perform: dataController.save)

    }  //: body

    func update() {
        project.title = title
        project.detail = detail
        project.color = color
        project.creationDate = Date()
        if dueOn {
            project.dueDate = dueDate
            dataController.addDueDateReminder(for: project) { success in
                if success == false {
                    project.dueDate = nil
                    dueOn = false
                    //                    showingNotificationsError.toggle()
                }
            }
        } else {
            project.dueDate = nil
            dataController.removeDueReminder(for: project)
        }
        dataController.save()
    }

    func delete() {
        dataController.removeFromCloud(project)
        dataController.delete(project)
        self.presentationMode.wrappedValue.dismiss()
    }

    //    func colorButton(for item: String) -> some View {
    //        ZStack {
    //            Color(item)
    //                .aspectRatio(1, contentMode: .fit)
    //                .cornerRadius(6)
    //            if item == color {
    //                Image(systemName: "checkmark.circle")
    //                    .foregroundColor(.white)
    //                    .font(.largeTitle)
    //            }
    //        }  //: ZStack
    //        .onTapGesture {
    //            color = item
    //            update()
    //        }
    //    }
}
