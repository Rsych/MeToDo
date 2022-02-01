//
//  SettingsView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/27.
//

import SwiftUI

struct CustomizationView: View {
    // MARK: - Properties
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataController: DataController
    @State var notificationIsOn = false
    
    @Binding var darkModeEnabled: Bool
    @Binding var systemThemeEnabled: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
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
        }
        
        
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
        .navigationBackButton(color: UIColor.label, text: "More")
    }  //: Body
}

struct CustomizationView_Preview: PreviewProvider {
    static var previews: some View {
        CustomizationView(darkModeEnabled: .constant(true), systemThemeEnabled: .constant(false))
            .environmentObject(DataController())
    }
}
