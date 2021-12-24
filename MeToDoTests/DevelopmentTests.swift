//
//  DevelopmentTests.swift
//  MeToDoTests
//
//  Created by Ryan J. W. Kim on 2021/12/24.
//

import XCTest
@testable import MeToDo

class DevelopmentTests: BaseTestCase {
    func testCreateSampleData() throws {
        try dataController.createSampleData()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 5, "There should be 5 sample projects")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 25, "There should be 25 sample items")
    }

    func testDeleteAllTest() throws {
        try dataController.createSampleData()
        dataController.deleteAll()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 0, "deleteAll should delete all projects")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 0, "deleteAll should delete all items")
    }
}
