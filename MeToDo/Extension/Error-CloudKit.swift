//
//  Error-CloudKit.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/30.
//

import Foundation
import CloudKit

extension Error {
    func getCloudKitError() -> String {
        guard let error = self as? CKError else {
            return "An unknown error occurred: \(self.localizedDescription)"
        }

        switch error.code {

            // Logic error, if it happens my code sucks
        case .badContainer, .badDatabase, .invalidArguments:
            return "A fatal error occurred: \(error.localizedDescription)"
            // Usually client side error with network connection, or iCloud is down.
        case .networkFailure, .networkUnavailable, .serverResponseLost, .serviceUnavailable:
            return "There was a problem communicating with iCloud, please check your network connection and try again."
            // User did not logged in
        case .notAuthenticated:
            return "There was a problem with your iCloud account; please check that you're logged in to iCloud."
            // Too many requests
        case .requestRateLimited:
            return "You've hit iCloud's rate limit; please wait a moment then try again."
            // User private iCloud quota is full. Or my dev public storage is full (unlikely)
        case .quotaExceeded:
            return "You've exceeded your iCloud quota; please clear up some space then try again."
            // Unknown error
        default:
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
