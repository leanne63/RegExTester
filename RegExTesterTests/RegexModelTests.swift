//
//  RegexModelTests.swift
//  RegExTester
//
//  Created by leanne on 5/10/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import XCTest

class RegexModelTests: XCTestCase {
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testModelMessageNilAtStart() {
		
		let regexModel = RegexModel()
		
		XCTAssertNil(regexModel.message)
    }
	
	func testModelMatchArrayEmptyAtStart() {
		
		let regexModel = RegexModel()
		let emptyStringArray = [String]()
		
		XCTAssertEqual(emptyStringArray, regexModel.matchArray)
	}
	
}
