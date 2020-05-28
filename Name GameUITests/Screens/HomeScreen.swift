//
//  HomeScreen.swift
//  Name GameUITests
//
//  Created by Michal Hus on 5/27/20.
//  Copyright © 2020 Michal Hus. All rights reserved.
//

import XCTest

class HomeScreen: BaseScreen {
        
    var homeView: XCUIElement {
        return app.otherElements.matching(identifier: "homeView").element
    }
    
    var homeImage: XCUIElement {
        return app.images.matching(identifier: "homeImage").element
    }
    
    var practiceMode: XCUIElement {
        return app.buttons.matching(identifier: "practiceMode").element
    }
    
    var timeMode: XCUIElement {
        return app.buttons.matching(identifier: "timeMode").element
    }
}
