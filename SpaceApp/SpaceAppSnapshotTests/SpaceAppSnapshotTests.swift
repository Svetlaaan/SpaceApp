//
//  SpaceAppSnapshotTests.swift
//  SpaceAppSnapshotTests
//
//  Created by Svetlana Fomina on 30.07.2021.
//

import XCTest
import SnapshotTesting

@testable import SpaceApp

class SettingsViewControllerSnapshotTest: XCTestCase {

    func testSettingsViewControllerSnapshot() throws {
        // isRecording = true - to record all new references
        // isRecording = false - not to record all new references
//        isRecording = true
        let sut = SettingsController()
        assertSnapshot(matching: sut, as: .image(on: .iPhoneX))
    }

}
