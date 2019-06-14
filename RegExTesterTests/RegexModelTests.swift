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
		let emptyRangeArray = [[Range<String.Index>]]()
		
		XCTAssertEqual(emptyRangeArray.count, regexModel.matchArray.count)
	}
	
	func testModelEmptyPatternResponse() {
		
		let regexModel = RegexModel()
		let pattern = ""
		let compareString = "This is my compare string!"
		let options = NSRegularExpression.Options()
		
		regexModel.findRegexMatchesWithPattern(pattern, compareString: compareString, regexOptions: options)
		
		let expectedMessage = "Unable to configure RegEx object with specified pattern (/<empty!>/)."
		let emptyRangeArray = [[Range<String.Index>]]()
		
		XCTAssertEqual(expectedMessage, regexModel.message)
		XCTAssertEqual(emptyRangeArray.count, regexModel.matchArray.count)
	}
	
	func testModelSendsProperNotification(_ notification: Notification?) {
		// TODO: finish this function
		// looks like notification expectations are coming out in Swift 3.0:
		// https://github.com/apple/swift-corelibs-xctest/blob/master/Sources/XCTest/XCNotificationExpectationHandler.swift
	}
	
	func testModelHasValidMatchArray() {
		
		let regexModel = RegexModel()
		let pattern = "ABC"
		let compareString = "ABC"
		let options = NSRegularExpression.Options()
		
		regexModel.findRegexMatchesWithPattern(pattern, compareString: compareString, regexOptions: options)
		
		let rangeStart = compareString.index(compareString.startIndex, offsetBy: 0)
		let rangeEnd = compareString.index(compareString.startIndex, offsetBy: 0 + 3)
		let matchRange = Range(uncheckedBounds: (rangeStart, rangeEnd))
		
		let expectedArray = [[matchRange]]

		XCTAssertEqual(expectedArray[0][0], regexModel.matchArray[0][0])
	}
	
	func testModelHasValidMatchArrayWithGroup() {
		
		let regexModel = RegexModel()
		let pattern = "A(BC)"
		let compareString = "ABC"
		let options = NSRegularExpression.Options()
		
		regexModel.findRegexMatchesWithPattern(pattern, compareString: compareString, regexOptions: options)
		
		let rangeStart = compareString.index(compareString.startIndex, offsetBy: 0)
		let rangeEnd = compareString.index(compareString.startIndex, offsetBy: 0 + 3)
		let matchRange = Range(uncheckedBounds: (rangeStart, rangeEnd))
		
		let groupRangeStart = compareString.index(compareString.startIndex, offsetBy: 1)
		let groupRangeEnd = compareString.index(compareString.startIndex, offsetBy: 1 + 2)
		let groupRange = Range(uncheckedBounds: (groupRangeStart, groupRangeEnd))
		
		let expectedArray = [[matchRange, groupRange]]

		XCTAssertEqual(expectedArray[0][0], regexModel.matchArray[0][0])
		XCTAssertEqual(expectedArray[0][1], regexModel.matchArray[0][1])
	}
	
	func testModelHasValidMatchArrayCaseInsensitive() {
		
		let regexModel = RegexModel()
		let pattern = "ABC"
		let compareString = "abc"
		let options = NSRegularExpression.Options.caseInsensitive
		
		regexModel.findRegexMatchesWithPattern(pattern, compareString: compareString, regexOptions: options)
		
		let rangeStart = compareString.index(compareString.startIndex, offsetBy: 0)
		let rangeEnd = compareString.index(compareString.startIndex, offsetBy: 0 + 3)
		let matchRange = Range(uncheckedBounds: (rangeStart, rangeEnd))
		
		let expectedArray = [[matchRange]]
		
		XCTAssertEqual(expectedArray[0][0], regexModel.matchArray[0][0])
	}
	
	func testModelHasValidMatchArrayWithGroupCaseInsensitive() {
		
		let regexModel = RegexModel()
		let pattern = "A(BC)"
		let compareString = "abc"
		let options = NSRegularExpression.Options.caseInsensitive
		
		regexModel.findRegexMatchesWithPattern(pattern, compareString: compareString, regexOptions: options)
		
		let rangeStart = compareString.index(compareString.startIndex, offsetBy: 0)
		let rangeEnd = compareString.index(compareString.startIndex, offsetBy: 0 + 3)
		let matchRange = Range(uncheckedBounds: (rangeStart, rangeEnd))
		
		let groupRangeStart = compareString.index(compareString.startIndex, offsetBy: 1)
		let groupRangeEnd = compareString.index(compareString.startIndex, offsetBy: 1 + 2)
		let groupRange = Range(uncheckedBounds: (groupRangeStart, groupRangeEnd))
		
		let expectedArray = [[matchRange, groupRange]]
		
		XCTAssertEqual(expectedArray[0][0], regexModel.matchArray[0][0])
		XCTAssertEqual(expectedArray[0][1], regexModel.matchArray[0][1])
	}
	
	func testModelHasValidMatchArrayWithEmoji() {
		
		// \\N{Face without mouth}
		/*
		😶
		Face without mouth
		Unicode: U+1F636, UTF-8: F0 9F 98 B6
		*/
		
		/*
		😏
		Smirking face
		Unicode: U+1F60F, UTF-8: F0 9F 98 8F
		*/
		
		let regexModel = RegexModel()
		let pattern = "A\\U0001F636C"
		let compareString = "A😶C"
		let options = NSRegularExpression.Options()
		
		regexModel.findRegexMatchesWithPattern(pattern, compareString: compareString, regexOptions: options)
		
		let rangeStart = compareString.index(compareString.startIndex, offsetBy: 0)
		let rangeEnd = compareString.index(compareString.startIndex, offsetBy: 0 + 3)
		let matchRange = Range(uncheckedBounds: (rangeStart, rangeEnd))
		
		let expectedArray = [[matchRange]]
		
		XCTAssertEqual(expectedArray[0][0], regexModel.matchArray[0][0])
	}
	
	func testModelHasValidMatchArrayWithGroupWithEmoji() {
		
		let regexModel = RegexModel()
		let pattern = "A(\\N{Face without mouth}C)"
		let compareString = "A😶C"
		let options = NSRegularExpression.Options()
		
		regexModel.findRegexMatchesWithPattern(pattern, compareString: compareString, regexOptions: options)
		
		let rangeStart = compareString.index(compareString.startIndex, offsetBy: 0)
		let rangeEnd = compareString.index(compareString.startIndex, offsetBy: 0 + 3)
		let matchRange = Range(uncheckedBounds: (rangeStart, rangeEnd))
		
		let groupRangeStart = compareString.index(compareString.startIndex, offsetBy: 1)
		let groupRangeEnd = compareString.index(compareString.startIndex, offsetBy: 1 + 2)
		let groupRange = Range(uncheckedBounds: (groupRangeStart, groupRangeEnd))
		
		let expectedArray = [[matchRange, groupRange]]
		
		XCTAssertEqual(expectedArray[0][0], regexModel.matchArray[0][0])
		XCTAssertEqual(expectedArray[0][1], regexModel.matchArray[0][1])
	}
	
}
