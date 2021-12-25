//
//  PerformanceTests.swift
//  MeToDoTests
//
//  Created by Ryan J. W. Kim on 2021/12/25.
//

import XCTest
@testable import MeToDo

class PerformanceTests: BaseTestCase {
    func testPerformanceExample() throws {
        try dataController.createSampleData()
        let awards = Award.allAwards

        self.measure {
            _ = awards.filter(dataController.hasEarned(award:))
        }
    }

    func testAwardsCalculationPerformance() throws {
        // creates large amount of data
        for _ in 1...100 {
            try dataController.createSampleData()
        }
        // Simulate lots of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()

        XCTAssertEqual(awards.count, 500, "Current constants of awards is 500, Change later if changed")
        self.measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }
}
