//
//  AwardsTests.swift
//  MeToDoTests
//
//  Created by Ryan J. W. Kim on 2021/12/24.
//

import XCTest
import CoreData
@testable import MeToDo

class AwardsTests: BaseTestCase {
    let awards = Award.allAwards

    func testAwardIDMatch() {
        for award in awards {
            XCTAssertEqual(award.id, award.name)
        }
    }

    func testNoAwardNewUser() throws {
        for award in awards {
            XCTAssertFalse(dataController.hasEarned(award: award), "New User should have none")
        }
    }

    func testAddItems() throws {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (count, value) in values.enumerated() {

            for _ in 0..<value {
                _ = Item(context: managedObjectContext)
            }

            let matches = awards.filter { award in
                award.criterion == "items" && dataController.hasEarned(award: award)
            }
            XCTAssertEqual(matches.count, count + 1, "Adding \(value) items should unlock \(count + 1) awards.")

            dataController.deleteAll()
        }
    }

    func testCompletedAwards() throws {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (count, value) in values.enumerated() {

            for _ in 0..<value {
                let item = Item(context: managedObjectContext)
                item.completed = true
            }

            let matches = awards.filter { award in
                award.criterion == "complete" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count + 1, "Completing \(value) items should unlock \(count + 1) awards.")

            dataController.deleteAll()
        }
    }

    func testExampleProjectIsClosed() throws {
        let project = Project.example
        XCTAssertTrue(project.closed, "The example project should be closed")
    }
    
    func testExampleItemPriorityHigh() throws {
        let item = Item.example
        XCTAssertEqual(item.priority, 2, "The created test item priority should be medium (2)")
    }
}
