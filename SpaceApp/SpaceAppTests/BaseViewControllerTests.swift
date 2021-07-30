//
//  BaseViewControllerTests.swift
//  SpaceAppTests
//
//  Created by Svetlana Fomina on 28.07.2021.
//

import XCTest
@testable import SpaceApp

class BaseViewControllerTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    let sut = BaseViewController()

    func testThatSpinnerShowsWhenLoadingStart() {
        /// Arrange
        sut.isLoading = false
        sut.isLoading = true

        /// Act
        let result = sut.showSpinner(isShown: sut.isLoading)

        /// Assert
        XCTAssertTrue(result)
    }

    func testThatSpinnerNotShowsWhenLoadingFinish() {
        /// Arrange
        sut.isLoading = true
        sut.isLoading = false

        /// Act
        let result = sut.showSpinner(isShown: sut.isLoading)

        /// Assert
        XCTAssertFalse(result)
    }
}
