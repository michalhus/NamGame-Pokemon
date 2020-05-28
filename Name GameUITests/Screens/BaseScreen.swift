//
//  BaseScreen.swift
//  Name GameUITests
//
//  Created by Michal Hus on 5/27/20.
//  Copyright © 2020 Michal Hus. All rights reserved.
//

import XCTest

protocol BaseScreen {}

extension BaseScreen {
    
    var app: XCUIApplication {
        return XCUIApplication()
    }
}
