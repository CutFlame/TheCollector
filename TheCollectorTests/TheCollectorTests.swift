//
//  TheCollectorTests.swift
//  TheCollectorTests
//
//  Created by Michael Holt on 7/19/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

@testable import TheCollector
import XCTest
import ReactiveSwift

class TheCollectorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class EditItemViewModelTests: XCTestCase {
    let categoryID = UUID()
    let database = InMemoryDatabase()

    func testConstructor() {
        let category = Category.init(categoryID: categoryID, name: "Test Category", itemIDs: [])
        let instance = EditItemViewModel(category: category, item: nil, database: database)
        XCTAssertNotNil(instance)
    }

    func testCannotInitiallySave() {
        let category = Category.init(categoryID: categoryID, name: "Test Category", itemIDs: [])
        let instance = EditItemViewModel(category: category, item: nil, database: database)
        XCTAssert(instance.saveAction.isEnabled.value == false)
    }

    func testSaveIsEnabled() {
        let category = Category.init(categoryID: categoryID, name: "Test Category", itemIDs: [])
        let instance = EditItemViewModel(category: category, item: nil, database: database)
        instance.title.value = "Test Title"
        instance.description.value = "Test Description"
        XCTAssert(instance.saveAction.isEnabled.value)
    }
    func testSave() {
        let category = Category.init(categoryID: categoryID, name: "Test Category", itemIDs: [])
        let instance = EditItemViewModel(category: category, item: nil, database: database)
        instance.title.value = "Test Title"
        instance.description.value = "Test Description"
        instance.saveAction
    }
}
