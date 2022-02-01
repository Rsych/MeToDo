//
//  SecurityView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2022/01/09.
//

import SwiftUI

struct SecurityView: View {
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    
    // Biometric lock
    @EnvironmentObject var appLockVM: AppLockViewModel
    // MARK: - Body
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $appLockVM.isAppLockEnabled, label: {
                    Text("Face ID / Passcode")
                } )
                    .onChange(of: appLockVM.isAppLockEnabled, perform: { value in
                        appLockVM.appLockStateChange(appLockState: value)
                    })
            } header: {
                Text("Security")
            } footer: {
                Text("Lock MeToDo when app goes into background, or closed. Unlock with Biometric authentication or enter your passcode.")
            }
        } //: Form
        .background(Color(uiColor: .systemBackground))
        .listRowBackground(Color.clear)
        
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = UIColor.clear
            UITableViewCell.appearance().backgroundColor = UIColor.clear
        })
        .navigationBarBackButtonHidden(true)
        .navigationBackButton(color: UIColor.label, text: "More")
    } //: body
}
