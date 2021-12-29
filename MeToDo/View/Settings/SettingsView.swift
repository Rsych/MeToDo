//
//  SettingsView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/27.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataController: DataController
    @State var notificationIsOn = false
    var body: some View {
        Form {
            Section {
                Text("Settings View")
                    .onAppear {
                        dataController.checkPushNotification { isOn in
                            notificationIsOn = isOn
                            print(notificationIsOn)
                        }
                    }

                Toggle(isOn: $notificationIsOn) {
                    Text(notificationIsOn ? "Notification enabled" : "Enable notification")
                } .disabled(notificationIsOn ? true : false)
                    .onTapGesture {
                        if notificationIsOn {

                        } else {
                            dataController.showAppSettings()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }  //: OnTap
            }  //: Section
        }  //: Form
    }  //: Body
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
