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

    @State var notificationIsOn = false
    @State var isItOn = false

    var body: some View {

        Section {
            if isItOn {
                Toggle("Add due date", isOn: $dueOn.animation())
                if dueOn {
                    DatePicker("Pick a date", selection: $dueDate, in: Date()..., displayedComponents: .date)
                }
            } else {
                Button {
                    self.notificationIsOn.toggle()
                } label: {
                    Toggle("Add due date", isOn: $dueOn.animation())
                }
                .foregroundColor(isItOn ? .primary : .red)
            }
        } header: {
            Text("Due date")
        }
        .onAppear(perform: {
            dataController.checkPushNotification { isOn in
                isItOn = isOn
            }
        })
        .onTapGesture {
            dataController.checkPushNotification { isOn in
                notificationIsOn = !isOn
                isItOn = isOn
            }
        }
        // There's an error that notification terminates immediately after showing Alert
        // Fix this later
        .alert(isPresented: $notificationIsOn) {
            Alert(
                title: Text("Oops!"),
                message: Text("There was a problem. Please check you have notifications enabled."),
                primaryButton: .default(Text("Check Settings"), action: dataController.showAppSettings),
                secondaryButton: .cancel()
            )
        }

    }
}
