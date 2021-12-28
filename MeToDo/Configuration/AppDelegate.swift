//
//  AppDelegate.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/28.
//

import Foundation
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    // appShortcut delegate
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }
}
