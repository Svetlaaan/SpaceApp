//
//  SpaceAppSnapshotsTests.swift
//  SpaceAppSnapshotsTests
//
//  Created by Svetlana Fomina on 30.07.2021.
//

import XCTest
import SnapshotTesting

@testable import SpaceApp

class SettingsViewControllerSnapshotTest: XCTestCase {

    func testSettingsViewControllerSnapshot() throws {
        // isRecording - Whether or not to record all new references.
        let sut = SettingsController()
        assertSnapshot(matching: sut, as: .image(on: .iPhoneX))
    }

}
