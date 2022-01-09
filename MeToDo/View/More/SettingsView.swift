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
    
    @Environment(\.colorScheme) var colorScheme
    
    // Biometric lock
    @EnvironmentObject var appLockVM: AppLockViewModel

    // MARK: - Properties
    var body: some View {
//        NavigationView {
        Form {
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
            
            Section {
                Toggle(isOn: $appLockVM.isAppLockEnabled, label: {
                    Text("Face ID / Passcode")
                } )
                    .onChange(of: appLockVM.isAppLockEnabled, perform: { value in
                        appLockVM.appLockStateChange(appLockState: value)
//                        self.presentationMode.wrappedValue.dismiss()
                    })
            } header: {
                Text("Security")
            } footer: {
                Text("Lock MeToDo when app goes into background, or closed. Unlock with Biometric authentication or enter your passcode.")
            }
        }  //: Form
        
//        .toolbar(content: {
//            ToolbarItem(placement: .navigation) {
//                Text("Settings")
//                    .font(.title)
//            }
//        })
//        .navigationBackButton(color: UIColor.label)
        
//        } //: NavView

        // MARK: - ETC
        .background(Color(uiColor: .systemBackground))
                    .listRowBackground(Color.clear)

                    .onAppear(perform: {
                        UITableView.appearance().backgroundColor = UIColor.clear
                        UITableViewCell.appearance().backgroundColor = UIColor.clear
                    })
        .onAppear {
            dataController.checkPushNotification { isOn in
                notificationIsOn = isOn
                print(notificationIsOn)
                if colorScheme == .dark {
                    darkModeEnabled = true
                }
            }
        }  //: onAppear
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .navigation) {
                Text("Settings")
                    .font(.title)
            }
        })
        .navigationBackButton(color: UIColor.label)
    }  //: Body
}
