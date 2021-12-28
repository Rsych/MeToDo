//
//  DueDateView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/27.
//

import SwiftUI

struct DueDateView: View {
    @EnvironmentObject var dataController: DataController
    @Binding var dueOn: Bool
    @Binding var dueDate: Date

    var body: some View {

        Section {
            Toggle("Add due date", isOn: $dueOn.animation())
            if dueOn {
                DatePicker("Pick a date", selection: $dueDate, in: Date()..., displayedComponents: .date)
            }
        } header: {
            Text("Due date")
        }

    }
}
