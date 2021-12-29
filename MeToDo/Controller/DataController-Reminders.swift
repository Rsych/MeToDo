//
//  DataController-Reminders.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/28.
//

import UIKit
import UserNotifications
import CoreSpotlight

extension DataController {
    /// For DueDate reminder
    func addDueDateReminder(for project: Project, completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()

        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestNotification { success in
                    if success {
                        self.placeDueReminder(for: project, completion: completion)
                    } else {
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    }
                }
            case .authorized:
                self.placeDueReminder(for: project, completion: completion)
            default:
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    /// Removes notification
    func removeDueReminder(for project: Project) {
        let center = UNUserNotificationCenter.current()
        let id = project.objectID.uriRepresentation().absoluteString
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    /// Request for Notification center, user to agree notification
    private func requestNotification(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            completion(granted)
        }
    }
    private func placeDueReminder(for project: Project, completion: @escaping (Bool) -> Void) {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = project.projectTitle

        if let projectDetail = project.detail {
            content.subtitle = projectDetail
        }

        let components = Calendar.current.dateComponents([.year, .month, .day], from: project.dueDate ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let id = project.objectID.uriRepresentation().absoluteString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if error == nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    ///  Deletes reminder when a project is deleted
    func delete(_ object: Project) {
        let id = object.objectID.uriRepresentation().absoluteString
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [id])
        removeDueReminder(for: object)
        container.viewContext.delete(object)
    }

    func checkPushNotification(checkNotificationStatus isEnable: ((Bool) -> Void)? = nil) {

            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().getNotificationSettings { (settings) in

                    switch settings.authorizationStatus {
                    case .authorized:

                        print("enabled notification setting")
                        isEnable?(true)
                    case .denied:

                        print("setting has been disabled")
                        isEnable?(false)
                    default:

                        print("something vital went wrong here")
                        isEnable?(false)
                    }
                }
            } else {

                let isNotificationEnabled = UIApplication.shared
                    .currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert)
                if isNotificationEnabled == true {

                    print("enabled notification setting")
                    isEnable?(true)

                } else {

                    print("setting has been disabled")
                    isEnable?(false)
                }
            }
        }
}
