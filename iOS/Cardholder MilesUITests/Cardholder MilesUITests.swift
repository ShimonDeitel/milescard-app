import XCTest

final class CardholderMilesUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddEntryFlow() {
        app.buttons["addEntryButton"].tap()
        let field1 = app.textFields["field_programName"]
        XCTAssertTrue(field1.waitForExistence(timeout: 2))
        field1.tap()
        field1.typeText("New Entry")
        app.buttons["formSaveButton"].tap()
        XCTAssertTrue(app.staticTexts["New Entry"].waitForExistence(timeout: 2))
    }

    func testFreeLimitTriggersPaywall() {
        for i in 0..<10 {
            let addButton = app.buttons["addEntryButton"]
            if addButton.exists { addButton.tap() }
            let field1 = app.textFields["field_programName"]
            if field1.waitForExistence(timeout: 1) {
                field1.tap()
                field1.typeText("Entry \(i)")
                app.buttons["formSaveButton"].tap()
            } else {
                break
            }
        }
        XCTAssertTrue(app.buttons["paywallPurchaseButton"].waitForExistence(timeout: 2) || app.staticTexts["Cardholder Miles Pro"].waitForExistence(timeout: 2))
    }

    func testKeyboardDismissOnTapOutside() {
        app.buttons["addEntryButton"].tap()
        let field1 = app.textFields["field_programName"]
        XCTAssertTrue(field1.waitForExistence(timeout: 2))
        field1.tap()
        field1.typeText("Dismiss Test")
        app.navigationBars.staticTexts.firstMatch.tap()
        XCTAssertFalse(app.keyboards.element.exists)
    }
}
