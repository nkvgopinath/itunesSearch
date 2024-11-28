//
//  itunesapiUITestsLaunchTests.swift
//  itunesapiUITests
//
//  Created by Gopinath Vaiyapuri on 20/11/24.
//

import XCTest

final class itunesapiUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func testInitialUIState() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.textFields["searchTextField"].exists, "Search text field should exist.")
        XCTAssertTrue(app.buttons["submitButton"].exists, "Submit button should exist.")
        XCTAssertTrue(app.collectionViews["collectionView"].exists, "Collection view should exist.")

    }
    
    func testSearchButtonWithoutInput() {
        let app = XCUIApplication()
        app.launch()

        let submitButton = app.buttons["submitButton"]
        submitButton.tap()

        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.exists, "An alert should be displayed.")
        XCTAssertEqual(alert.label, "Error", "The alert title should be 'Error'.")
        XCTAssertTrue(alert.staticTexts["Please enter the search data"].exists, "The alert should display a relevant error message.")
    }
    
    func testSearchAction() throws {
        let app = XCUIApplication()
        app.launch()

        let searchTextField = app.textFields["searchTextField"]
        searchTextField.tap()
        searchTextField.typeText("Elon Musk")

        let submitButton = app.buttons["submitButton"]
        submitButton.tap()

        let newScreen = app.otherElements["iTunesControllerView"]
        XCTAssertTrue(newScreen.waitForExistence(timeout: 5), "iTunesControllerView should be displayed after a search.")
        
        XCTAssertTrue(app.segmentedControls["segmentedControl"].exists, "Segmented control should exist.")
        XCTAssertTrue(app.otherElements["viewHolder"].exists, "View holder should exist.")
        


        let segmentedControl = app.segmentedControls["segmentedControl"]
        XCTAssertEqual(segmentedControl.buttons.count, 2, "Segment control should have 2 segments.")
        
        
        
        // Tap the first segment and verify if the first page view is visible
        let firstSegment = segmentedControl.buttons.element(boundBy: 0)
        XCTAssertTrue(firstSegment.exists, "First segment should exist.")
        firstSegment.tap()

        // Check that the first page view is displayed
        let firstPageView = app.otherElements["iTunesGridControllerView"]
        XCTAssertTrue(firstPageView.exists, "Grid view should be visible after selecting first segment.")
        
        // Tap the second segment and verify if the second page view is visible
        let secondSegment = segmentedControl.buttons.element(boundBy: 1)
        XCTAssertTrue(secondSegment.exists, "Second segment should exist.")
        secondSegment.tap()

        let secondPageView = app.otherElements["iTunesListControllerView"]
        XCTAssertTrue(secondPageView.exists, "List view should be visible after selecting second segment.")

        let backButton = app.buttons["Back"]
        XCTAssertTrue(backButton.exists, "Back button should be visible.")
        backButton.tap()
        




    }
    
    
}
