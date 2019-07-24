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
        let category = Category.init(categoryID: categoryID, name: "Test Category", itemIDs: [])
        try? database.save(category: category).first()?.get()
    }

    func testConstructor() {
        let instance = EditItemViewModel(categoryID: categoryID)
        XCTAssertNotNil(instance)
    }

    func testCannotInitiallySave() {
        let instance = EditItemViewModel(categoryID: categoryID)
        XCTAssert(instance.saveAction.isEnabled.value == false)
    }

    func testSaveIsEnabled() {
        let instance = EditItemViewModel(categoryID: categoryID)
        instance.title.value = "Test Title"
        instance.description.value = "Test Description"
        XCTAssert(instance.saveAction.isEnabled.value)
    }
    
    func testSaveNew() {
        let instance = EditItemViewModel(categoryID: categoryID)
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
        XCTAssertEqual(items?.count, 1)
        let item = items?.first
        XCTAssertEqual(item?.title, "Test Title")
        XCTAssertEqual(item?.description, "Test Description")
    }
}
