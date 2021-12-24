//
//  ExtensionsTests.swift
//  MeToDoTests
//
//  Created by Ryan J. W. Kim on 2021/12/25.
//

import XCTest
@testable import MeToDo

class ExtensionsTests: BaseTestCase {
    func testSort() throws {
        let items = [2, 3, 1, 5, 4, 6]
        let sortedItem = items.sorted()

        XCTAssertEqual(sortedItem, [1, 2, 3, 4, 5, 6], "Sorted array should be ascending")
    }
    func testSort2() throws {
        let items = [2, 3, 1, 5, 4, 6]
        let sortedItem = items.sorted(by: \.self)

        XCTAssertEqual(sortedItem, [1, 2, 3, 4, 5, 6], "Sorted array should be ascending")
    }

    func testSequenceSorted() throws {
        struct Example: Equatable {
                let value: String
            }

            let example1 = Example(value: "a")
            let example2 = Example(value: "b")
            let example3 = Example(value: "c")
            let array = [example1, example2, example3]

        let sortedArray = array.sorted(by: \.value) {
            $0 > $1
        }
        XCTAssertEqual(sortedArray, [example3, example2, example1], "Reverse sorting should yield c, b, a.")

    }

    func testBundleDecoding() throws {
        let awards = Bundle.main.decode([Award].self, from: "Awards.json")
        XCTAssertFalse(awards.isEmpty, "Awards.json should not be empty")
    }
}
