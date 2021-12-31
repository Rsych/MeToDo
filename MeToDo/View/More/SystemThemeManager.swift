//
//  SystemThemeManager.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/30.
//

import Foundation
import UIKit

class SystemThemeManager {
    static let shared = SystemThemeManager()
    private init() {}

    func handleTheme(darkMode: Bool, system: Bool) {
        // Handle system
        guard !system else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
            return
        }
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = darkMode ? .dark : .light
    }
}
