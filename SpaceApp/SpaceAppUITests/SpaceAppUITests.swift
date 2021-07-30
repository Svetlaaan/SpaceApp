//
//  SpaceAppUITests.swift
//  SpaceAppUITests
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import XCTest

protocol Page {
    var app: XCUIApplication { get }

    init(app: XCUIApplication)
}

class TabBarPage: Page {
    var app: XCUIApplication

    var mainButton: XCUIElement { return app.tabBars.buttons["Main"] }
    var historyButton: XCUIElement { return app.tabBars.buttons["History"] }
    var settingsButton: XCUIElement { return app.tabBars.buttons["Settings"] }

    required init(app: XCUIApplication) {
        self.app = app
    }

    func tapMainButton() -> MainPage {
        mainButton.tap()
        return MainPage(app: app)
    }

    func taphistoryButton() -> HistoryPage {
        historyButton.tap()
        return HistoryPage(app: app)
    }

    func tapSettingsButton() -> SettingsPage {
        settingsButton.tap()
        return SettingsPage(app: app)
    }
}

class MainPage: Page {
    var app: XCUIApplication

    required init(app: XCUIApplication) {
        self.app = app
    }
}

class HistoryPage: Page {
    var app: XCUIApplication

    required init(app: XCUIApplication) {
        self.app = app
    }
}

class SettingsPage: Page {
    var app: XCUIApplication

    required init(app: XCUIApplication) {
        self.app = app
    }

    var nameTextField: XCUIElement { return app.textFields["Enter your name"] }
    var emailTextField: XCUIElement { return app.textFields["Enter your email"] }
    var saveButton: XCUIElement { return app.buttons["Save"] }
    var clearButton: XCUIElement { return app.buttons["Clear"] }

    func typeName(name: String) -> Self {
        nameTextField.tap()
        nameTextField.typeText(name)
        return self
    }

    func typeEmail(email: String) -> Self {
        emailTextField.tap()
        emailTextField.typeText(email)
        return self
    }

    func tapSaveButton() -> Self {
        saveButton.tap()
        return self
    }

    func tapClearButton() -> Self {
        clearButton.tap()
        return self
    }

}

class SpaceAppUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testThatWhenTappedOnTabBarButtonsScreenOfThisButtonOpened() {

        let tabBarPage = TabBarPage(app: app)
        var mainButton: XCUIElement { return app.tabBars.buttons["Main"] }
        var historyButton: XCUIElement { return app.tabBars.buttons["History"] }
        var settingsButton: XCUIElement { return app.tabBars.buttons["Settings"] }

        _ = tabBarPage
            .tapSettingsButton()
        XCTAssertTrue(app.navigationBars["Settings"].exists)

        _ = tabBarPage
            .taphistoryButton()
        XCTAssertTrue(app.navigationBars["History"].exists)

       _ = tabBarPage
            .tapMainButton()
        XCTAssertTrue(app.navigationBars["Main"].exists)
    }

    func testThatTextFieldsClearedWhenClearButtonTapped() {
        /// Arrange
        let tabBarPage = TabBarPage(app: app)
        let nameTextFieldPlaceholder = "Enter your name"
        let emailTextFieldPlaceholder = "Enter your email"

        /// Act
        let settingPage = tabBarPage
            .tapSettingsButton()
            // очищает текстовые поля если до этого запускался
            // тест где сохранялись данные
            .tapClearButton()
            .typeName(name: "Test name")
            .typeEmail(email: "TestEmail@test.com")
            .tapClearButton()

        /// Assert
        let nameUserText = settingPage.nameTextField.value as? String
        let emailUserText = settingPage.emailTextField.value as? String
        if  nameUserText == nameTextFieldPlaceholder, emailUserText == emailTextFieldPlaceholder {
            XCTAssertFalse(nameUserText == "Test name")
            XCTAssertFalse(emailUserText == "TestEmail@test.com")
        } else {
            XCTAssertTrue(nameUserText == "Test name")
            XCTAssertTrue(emailUserText == "TestEmail@test.com")
        }
    }

    func testThatSaveButtonEnabledWhenNameAndTextFieldsNotEmpty() {
        /// Arrange
        let tabBarPage = TabBarPage(app: app)
        var saveButton: XCUIElement { return app.buttons["Save"] }

        /// Act
        let settingPage = tabBarPage
            .tapSettingsButton()
            // очищает текстовые поля если до этого запускался
            // тест где сохранялись данные
            .tapClearButton()
            .typeName(name: "Test name")
            .typeEmail(email: "TestEmail@test.com")

        /// Assert
        let nameUserText = settingPage.nameTextField.value as? String
        let emailUserText = settingPage.emailTextField.value as? String
        if  let nameUserText = nameUserText, let emailUserText = emailUserText {
            XCTAssertTrue(nameUserText == "Test name")
            XCTAssertTrue(emailUserText == "TestEmail@test.com")
            XCTAssertTrue(saveButton.isEnabled)
        }
    }

    func testThatSaveButtonDisabledWhenTappedWithNotEmptyTextFields() {
        /// Arrange
        let tabBarPage = TabBarPage(app: app)
        var saveButton: XCUIElement { return app.buttons["Save"] }

        /// Act
        let settingPage = tabBarPage
            .tapSettingsButton()
            // очищает текстовые поля если до этого запускался
            // тест где сохранялись данные
            .tapClearButton()
            .typeName(name: "Test name")
            .typeEmail(email: "TestEmail@test.com")
            .tapSaveButton()

        /// Assert
        let nameUserText = settingPage.nameTextField.value as? String
        let emailUserText = settingPage.emailTextField.value as? String
        if  let nameUserText = nameUserText, let emailUserText = emailUserText {
            XCTAssertTrue(nameUserText == "Test name")
            XCTAssertTrue(emailUserText == "TestEmail@test.com")
            XCTAssertTrue(!saveButton.isEnabled)
        }
    }
}
