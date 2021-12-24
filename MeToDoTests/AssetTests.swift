//
//  AssetTests.swift
//  MeToDoTests
//
//  Created by Ryan J. W. Kim on 2021/12/24.
//

import XCTest
@testable import MeToDo

class AssetTests: BaseTestCase {
    func testColor() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load \(color) from asset")
        }
    }

    func testJSONLoad() {
        XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load JSON")
    }
}
