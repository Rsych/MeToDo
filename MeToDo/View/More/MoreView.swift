//
//  MoreView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/30.
//

import SwiftUI

struct MoreView: View {
    // MARK: - Properties
    static let moreTag: Int = 4
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataController: DataController
    @State var notificationIsOn = false

    @Binding var darkModeEnabled: Bool
    @Binding var systemThemeEnabled: Bool
    // For later settings update
//    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
//    @AppStorage("systemThemeEnabled") private var systemThemeEnabled = false

    // MARK: - Body
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $notificationIsOn) {
                    Text(notificationIsOn ? "Notifications enabled" : "Enable notifications")
                } .disabled(notificationIsOn ? true : false)
                    .onTapGesture {
                        if !notificationIsOn {
                            dataController.showAppSettings()
                            notificationIsOn = false
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
        .navigationTitle("More")
        .navigationBarTitleDisplayMode(.inline)
//        NavigationView {
//            Text("More VIew")
//                .navigationTitle("More")
//                .navigationBarTitleDisplayMode(.automatic)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        NavigationLink {
//                            SettingsView(darkModeEnabled: $darkModeEnabled, systemThemeEnabled: $systemThemeEnabled)
//                        } label: {
//                            Image(systemName: "gear")
//                                .tint(.primary)
//                        }
//                    }
//                }
//        }  //: NavView
    }  //: body
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView(darkModeEnabled: .constant(false), systemThemeEnabled: .constant(false))
    }
}
