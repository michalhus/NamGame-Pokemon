//
//  Name_GameUITests.swift
//  Name GameUITests
//
//  Created by Michal Hus on 5/15/20.
//  Copyright © 2020 Michal Hus. All rights reserved.
//

import XCTest

class HomeTest: BaseTest {
    
    let homeScreen = HomeScreen()
    
    func testHomeScreen() {
        XCTAssert(homeScreen.homeView.waitForExistence(timeout: 10), "Element: \(homeScreen.homeImage) does not exist")
        XCTAssert(homeScreen.homeImage.waitForExistence(timeout: 10), "Element: \(homeScreen.homeImage) does not exist")
        XCTAssert(homeScreen.practiceMode.waitForExistence(timeout: 10), "Element: \(homeScreen.practiceMode) does not exist")
        XCTAssert(homeScreen.timeMode.waitForExistence(timeout: 10), "Element: \(homeScreen.timeMode) does not exist")
    }
    
    func testPracticeButton() {
        XCTAssert(homeScreen.homeView.waitForExistence(timeout: 10), "Element: \(homeScreen.homeImage) does not exist")
         XCTAssert(homeScreen.practiceMode.waitForExistence(timeout: 10), "Element: \(homeScreen.practiceMode) does not exist")
        homeScreen.practiceMode.tap()
        XCTAssertFalse(homeScreen.practiceMode.waitForExistence(timeout: 1), "Element: \(homeScreen.practiceMode) does exist")
        XCTAssertFalse(homeScreen.homeView.waitForExistence(timeout: 1), "Element: \(homeScreen.homeView) does exist")
    }
    
}
