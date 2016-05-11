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
	
	func testModelEmptyPatternResponse() {
		
		let regexModel = RegexModel()
		let pattern = ""
		let compareString = "This is my compare string!"
		let options = NSRegularExpressionOptions()
		
		regexModel.findRegexMatchesWithPattern(pattern, compareString: compareString, regexOptions: options)
		
		let expectedMessage = "Need a regular expression pattern to match."
		let emptyStringArray = [String]()
		
		XCTAssertEqual(expectedMessage, regexModel.message)
		XCTAssertEqual(regexModel.matchArray, emptyStringArray)
	}
	
}
