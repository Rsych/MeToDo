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
        UITableView.appearance().backgroundColor = UIColor.systemGroupedBackground
        return sceneConfiguration
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

            registerForNotification()
            return true
        }

        func registerForNotification() {
            // For device token and push notifications.
            UIApplication.shared.registerForRemoteNotifications()

            let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
            //        center.delegate = self

            center.requestAuthorization(options: [.sound, .alert, .badge ], completionHandler: { (_, error) in
                if error != nil { UIApplication.shared.registerForRemoteNotifications() } else {

                }
            })
        }
    
}
