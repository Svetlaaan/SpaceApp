//
//  UserSettingsServiceTest.swift
//  SpaceAppTests
//
//  Created by Svetlana Fomina on 30.07.2021.
//

import XCTest
@testable import SpaceApp

class UserSettingsServiceTest: XCTestCase {

    var defaultsService: UserSettingsService!

    override func setUpWithError() throws {
        try super.setUpWithError()

        defaultsService = UserSettingsService()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        defaultsService = nil
    }

    func testThatObjectSaved() {
        /// Arrange
        let testData = "testData"

        /// Act
        defaultsService.save(object: testData, for: "testObject")
        let getData: String? = defaultsService.object(for: "testObject")

        /// Assert
        XCTAssertEqual(testData, getData)
    }

    func testThatObjectDeleted() {
        /// Arrange
        let testData = "testData"

        /// Act
        defaultsService.save(object: testData, for: "testObject")
        defaultsService.removeObjectForKey(for: "testObject")
        let getData: String? = defaultsService.object(for: "testObject")

        /// Assert
        XCTAssertNil(getData)
    }

}
