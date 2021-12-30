//
//  SettingsView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/27.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - Properties

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataController: DataController
    @State var notificationIsOn = false

    @Binding var darkModeEnabled: Bool
    @Binding var systemThemeEnabled: Bool

    // MARK: - Properties
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $notificationIsOn) {
                    Text(notificationIsOn ? "Notifications enabled" : "Enable notifications")
                } .disabled(notificationIsOn ? true : false)
                    .onTapGesture {
                        if notificationIsOn {

                        } else {
                            dataController.showAppSettings()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }  //: OnTap
            } header: {
                Text("Notifications")
            } //: Notifications Section

            Section {
                Toggle(isOn: $darkModeEnabled) {
                    Text("Dark mode")
                }  //: Dark mode toggle
                .onChange(of: darkModeEnabled) { _ in
                    SystemThemeManager
                        .shared
                        .handleTheme(darkMode: darkModeEnabled, system: systemThemeEnabled)
                }
                Toggle(isOn: $systemThemeEnabled) {
                    Text("Use system settings")
                }
                .onChange(of: systemThemeEnabled) { _ in
                    SystemThemeManager
                        .shared
                        .handleTheme(darkMode: darkModeEnabled, system: systemThemeEnabled)
                }
            } header: {
                Text("Display")
            } footer: {
                Text("System settings will override Dark mode and use the current device theme")
            }  //: Display theme Section
        }  //: Form
        .onAppear {
            dataController.checkPushNotification { isOn in
                notificationIsOn = isOn
                print(notificationIsOn)
            }
        }  //: onAppear
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
//                            .foregroundColor(Color(UIColor.darkGray))
                            .tint(.primary)
                    }  //: HStack
                }  //: Button
            }  //: ToolbarItem
        }  //: Toolbar
    }  //: Body
}
