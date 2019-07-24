//
//  EditItemViewModelTests.swift
//  TheCollectorTests
//
//  Created by Michael Holt on 7/24/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

@testable import TheCollector
import XCTest
import ReactiveSwift

class EditItemViewModelTests: XCTestCase {
    let categoryID = UUID()
    let database = InMemoryDatabase()

    override func setUp() {
        super.setUp()
        Database.shared = self.database
    }

    func testConstructor() {
        let category = Category.init(categoryID: categoryID, name: "Test Category", itemIDs: [])
        let instance = EditItemViewModel(category: category)
        XCTAssertNotNil(instance)
    }

    func testCannotInitiallySave() {
        let category = Category.init(categoryID: categoryID, name: "Test Category", itemIDs: [])
        let instance = EditItemViewModel(category: category)
        XCTAssert(instance.saveAction.isEnabled.value == false)
    }

    func testSaveIsEnabled() {
        let category = Category.init(categoryID: categoryID, name: "Test Category", itemIDs: [])
        let instance = EditItemViewModel(category: category)
        instance.title.value = "Test Title"
        instance.description.value = "Test Description"
        XCTAssert(instance.saveAction.isEnabled.value)
    }
    
    func testSaveNew() {
        let category = Category.init(categoryID: categoryID, name: "Test Category", itemIDs: [])
        let instance = EditItemViewModel(category: category)
        instance.title.value = "Test Title"
        instance.description.value = "Test Description"
        do {
            try instance.saveAction.apply().first()?.get()
        } catch {
            XCTFail("Failed to save")
            return
        }
        let items = try? database.getItems(for: categoryID).first()?.get()
        XCTAssertNotNil(items)
        XCTAssert(items?.count == 1)
        let item = items?.first
        XCTAssert(item?.title == "Test Title")
        XCTAssert(item?.description == "Test Description")
    }
}
