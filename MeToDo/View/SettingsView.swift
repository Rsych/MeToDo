//
//  SettingsView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/27.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Text("Settings View")
    }
    
    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }

        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
