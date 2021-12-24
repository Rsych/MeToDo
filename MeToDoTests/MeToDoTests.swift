//
//  MeToDoTests.swift
//  MeToDoTests
//
//  Created by Ryan J. W. Kim on 2021/12/24.
//

import XCTest
import CoreData
@testable import MeToDo

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
