//
//  Name_GameTests.swift
//  Name GameTests
//
//  Created by Michal Hus on 5/15/20.
//  Copyright © 2020 Michal Hus. All rights reserved.
//

import XCTest
@testable import Name_Game

//THIS IS WRONG NEED TO FIX THIS BUT USE THIS NOW FOR PIPELINE INTEGRATION:
class Name_GameTests: XCTestCase {

    // This is only for temporarly use
    func testRandomTarget() {
        let timeVC = TimeMode()
        XCTAssertEqual(timeVC.randomTargetIndex, 0)
    }
    
    // This is only for temporarly use
    func testRandomTarget2() {
        let timeVC = TimeMode()
        XCTAssertEqual(timeVC.timeLeft, 60)
    }
    
}
