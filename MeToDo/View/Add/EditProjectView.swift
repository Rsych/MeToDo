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
    @State private var showingNotificationsError = false

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

//                DueDateView(dueOn: $dueOn, dueDate: $dueDate)
                Section(header: Text("Reminder")) {
                    Toggle("Show reminder", isOn: $dueOn.animation().onChange(update))
                        .alert(isPresented: $showingNotificationsError) {
                            Alert(
                                title: Text("Oops!"),
                                message: Text("There was a problem. Please check you have notifications enabled."),
                                primaryButton: .default(Text("Check Settings"), action: showAppSettings),
                                secondaryButton: .cancel()
                            )
                        }

                    if dueOn {
                        DatePicker(
                            LocalizedStringKey("Reminder time"),
                            selection: $dueDate.onChange(update),
                            in: Date()...,
                            displayedComponents: .date
                        )
                    }
                }
                .listRowBackground(Color(uiColor: .systemFill))
                .foregroundColor(Color.primary)

                Section {
                    Group {
                    Button(project.closed ? "Reopen" : "Mark it completed") {
                        presentationMode.wrappedValue.dismiss()

                        project.closed.toggle()
                        update()
                    }
                    .foregroundColor(.blue)
                    Button("Delete this todo") {
                        print("Delete")
                        showingDeleteConfirm.toggle()
                    }
                    .foregroundColor(.red)
                    }
                    .listRowBackground(Color(uiColor: .systemFill))
                    .foregroundColor(Color.primary)
                    .alert(isPresented: $showingDeleteConfirm) {
                        Alert(
                            title: Text("Delete todo?"),
                            message: Text("Are you sure you want to delete this todo? You will lose all the items inside."),
                            primaryButton: .destructive(Text("Delete"), action: delete),
                            secondaryButton: .cancel()
                        )
                    }  //: Delete Alert
                } footer: {
                    Text("Tasks in completed todo will not appear on home screen nor widgets.")
                } // section 3
            }  //: Form
            .background(Color(uiColor: .systemBackground))
                        .listRowBackground(Color.clear)

                        .onAppear(perform: {
                            UITableView.appearance().backgroundColor = UIColor.clear
                            UITableViewCell.appearance().backgroundColor = UIColor.clear
                        })
            .font(.body)
            .resignKeyboardOnDragGesture()

            .navigationTitle("Edit Todo")
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
                    showingNotificationsError = true
                }
            }
        } else {
            project.dueDate = nil
            dataController.removeDueReminder(for: project)
        }
        dataController.save()
    }

    func delete() {
        dataController.removeDueReminder(for: project)
        dataController.removeFromCloud(project)
        dataController.delete(project)
        self.presentationMode.wrappedValue.dismiss()
    }
    func showAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
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
