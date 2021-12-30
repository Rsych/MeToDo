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
            .onAppear {
                dataController.checkPushNotification { isOn in
                    notificationIsOn = isOn
                    print(notificationIsOn)
                }
            }
        }  //: Form
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                        Button(action: {presentationMode.wrappedValue.dismiss()}, label: {
                            HStack {
                            Image(systemName: "chevron.backward")
//                                .foregroundColor(Color(UIColor.darkGray))
                                    .tint(.primary)
                            }
                        })
        )
    }  //: Body
}
