//
//  Constants.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2022/01/01.
//

import Foundation
import UIKit

let uuid = UIDevice.current.identifierForVendor?.uuidString

enum Constants {
    static let errorPage = "https://naolin.net/error"
    static let twitter = "https://twitter.com/Naolin_dev"
    static let medium = "https://medium.com/@naolin"
    static let adminEmail = ["naolin@naolin.net"]
    static let subject = "[iOS] subject here"
    static let msgBody =
"""
--------------------
Please write here.







--------------------
App Name: \(Bundle.main.appName)
App Version: \(Bundle.main.appVersionLong)
Identifier: \(uuid?.description ?? "")
"""
}
