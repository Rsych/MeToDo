//
//  Constants.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2022/01/01.
//

import Foundation
import UIKit

let uuid = UIDevice.current.identifierForVendor?.uuidString

struct Constants {
    static let errorPage = "https://naolin.net/error"
    static let twitter = "https://twitter.com/Naolin_dev"
    static let medium = "https://medium.com/@naolin"
    static let appNotice = "https://rsych.github.io/MeToDo-web/changelog/"
    static let appWebsite = "https://rsych.github.io/MeToDo-web/"
    static let appFAQs = "https://woozy-archduke-bfe.notion.site/MeToDo-FAQs-665e5563643d4b1597b8abdf030a22c6"
    static let appTNC = "https://www.app-privacy-policy.com/live.php?token=ZuaSMtVr9EJOVRFsQbT3dIx4tMyHhcZe"
    static let appPrivacy = "https://www.app-privacy-policy.com/live.php?token=Y7UQg9oQzgj7Fn3BdnszPaVysRucAiZq"
    static let appEULA = "https://www.app-privacy-policy.com/live.php?token=TqYU0mZvliLWGHDnT4T2XZE3CyXuTLhX"

    /* Send Email properties */
    static let adminEmail = ["metodooapp@gmail.com"]
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
    
    private init() {}
}
