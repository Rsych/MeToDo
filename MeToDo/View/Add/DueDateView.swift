//
//  DueDateView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/27.
//

import SwiftUI

struct DueDateView: View {
    // MARK: - Properties
    
    @EnvironmentObject var dataController: DataController
    @Binding var dueOn: Bool
    @Binding var dueDate: Date

    @State var notificationIsOn = false
    @State var isItOn = false
    @State private var showingNotificationsError = false
    
// MARK: - Body
    var body: some View {
        Section {
            Toggle("Show reminder", isOn: $dueOn.animation())
                .listRowBackground(Color(uiColor: .systemFill))
                .foregroundColor(Color.primary)
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
                DatePicker(
                    LocalizedStringKey("Reminder time"),
                    selection: $dueDate,
                    in: Date()...,
                    displayedComponents: .date
                )
                .listRowBackground(Color(uiColor: .systemFill))
//                    .datePickerStyle(.graphical)
            }
        } header: {
            Text("Reminder")
        }

    }
}

struct DueDateView_Preview: PreviewProvider {
    static var previews: some View {
        DueDateView(dueOn: .constant(true), dueDate: .constant(Date()))
            .environmentObject(DataController())
    }
}
