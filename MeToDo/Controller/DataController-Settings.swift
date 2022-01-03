//
//  DataController-Settings.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/28.
//

import Foundation
import StoreKit

extension DataController {
    /// User review
    /// When inAppPurchase is enabled use below commented lines with new activationState.
    func appLaunched() {
        guard count(for: Project.fetchRequest()) >= 5 else { return }

        let allScenes = UIApplication.shared.connectedScenes
        // for later inApp unlock
        //        let scene = allScenes.first { $0.activationState == .foregroundActive }
        let scene = allScenes.first
        if let windowScene = scene as? UIWindowScene { SKStoreReviewController.requestReview(in: windowScene)}
    }
    /// Requests review right away!
    func showReview() {
        let allScenes = UIApplication.shared.connectedScenes
        let scene = allScenes.first
        if let windowScene = scene as? UIWindowScene { SKStoreReviewController.requestReview(in: windowScene)}
    }
    /// Opens Notifications in iPhone Settings
    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }

        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}
