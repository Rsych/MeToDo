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

    func testItemAwards() throws {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (count, value) in values.enumerated() {
            var items = [Item]()

            for _ in 0..<value {
                let item = Item(context: managedObjectContext)
                items.append(item)
            }

            let matches = awards.filter { award in
                award.criterion == "items"
            }
        }
    }
}
