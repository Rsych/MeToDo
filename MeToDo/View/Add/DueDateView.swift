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
                DatePicker(
                    LocalizedStringKey("Reminder time"),
                    selection: $dueDate,
                    in: Date()...,
                    displayedComponents: .date
                )
                    .datePickerStyle(.graphical)
            }
        }
        .listRowBackground(Color(uiColor: .systemFill))
        .foregroundColor(Color.primary)
    }
}

struct DueDateView_Preview: PreviewProvider {
    static var previews: some View {
        DueDateView(dueOn: .constant(true), dueDate: .constant(Date()))
            .environmentObject(DataController())
    }
}
