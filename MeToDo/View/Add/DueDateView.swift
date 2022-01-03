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
    @State private var showingNotificationsError = false

    var body: some View {
        Section(header: Text("Reminder")) {
            Toggle("Show reminder", isOn: $dueOn.animation())
                .onTapGesture {
                    dataController.checkPushNotification { isOn in
                        showingNotificationsError = !isOn
                    }
                }
                .alert(isPresented: $showingNotificationsError) {
                    Alert(
                        title: Text("Oops!"),
                        message: Text("There was a problem. Please check you have notifications enabled."),
                        primaryButton: .default(Text("Check Settings"), action: dataController.showAppSettings),
                        secondaryButton: .cancel()
                    )
                }
            if dueOn {
                DatePicker("Reminder time", selection: $dueDate, in: Date()..., displayedComponents: .date)
            }
        }
        .listRowBackground(Color(uiColor: .systemFill))
        .foregroundColor(Color.primary)

    }
}
