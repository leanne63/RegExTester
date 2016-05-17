//
//  RegexModel.swift
//  RegExTester
//
//  Created by leanne on 5/8/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import Foundation

class RegexModel {
	
	// MARK: - Properties
	
	// constants
	private let matchArrayDidChange = "matchArrayDidChange"
	private let matchArrayKey = "matchArray"
	private let messageDidChange = "messageDidChange"
	private let messageKey = "message"
	
	
	/// Holds any matches found.
	var matchArray = [[Range<String.CharacterView.Index>]]() {
		didSet {
			// TODO: create userinfo dictionary with Range<Index> type???
			print("didSet:\n\(matchArray)\n*****")
			//let userInfoDict = [matchArrayKey: matchArray as! AnyObject]
			NSNotificationCenter.defaultCenter().postNotificationName(matchArrayDidChange, object: nil, userInfo: nil)
		}
	}
	
	/// Holds any messages regarding issues with matching attempt.
	var message: String? {
		didSet {
			if let message = message {
				let userInfoDict = [messageKey: message]
				NSNotificationCenter.defaultCenter().postNotificationName(messageDidChange, object: nil, userInfo: userInfoDict)
			}
		}
	}
	
	
	// MARK: - Methods

	/**
	
	Checks for regular expression matches, including group captures, in a provided string.
	
	parameters:
		- regexPattern: The regular expression pattern on which to match.
		- compareString: The string in which to search for the matching pattern.
		- regexOptions: Any special pattern-matching options, such as NSRegularExpressionOptions.CaseInsensitive.
	
	*/
	func findRegexMatchesWithPattern(regexPattern: String, compareString: String, regexOptions: NSRegularExpressionOptions) {

		// create regex
		guard let regex = try? NSRegularExpression(pattern: regexPattern, options: regexOptions) else {
			let patternString = regexPattern.isEmpty ? "<empty!>" : regexPattern
			message = "Unable to configure RegEx object with specified pattern (/\(patternString)/)."
			return
		}
		
		let matchingOptions: NSMatchingOptions = NSMatchingOptions()
		
		// note that search range must be NSRange, even though compare string is a String (not NSString!) (as of Swift 2.2)
		// as a result, range length value must match NSString, NOT String (to allow for unicode characters such as emoji)
		let rangeLocation = 0
		let rangeLength = (compareString as NSString).length
		let searchRange = NSMakeRange(rangeLocation, rangeLength)
		
		// run the regex
		let matches = regex.matchesInString(compareString, options: matchingOptions, range: searchRange)

		guard matches.count > 0 else {
			message = "No matches found!"
			return
		}
		
		// matches come as NSRange values; we want to put Swift Range values into the array, though
		var matchList = [[Range<String.CharacterView.Index>]]()
		for (matchIndex, match) in matches.enumerate() {
			var tempArray = [Range<String.CharacterView.Index>]()
			
			let numRanges = match.numberOfRanges
			
			for currIndex in 0..<numRanges {
				let theNSRange = match.rangeAtIndex(currIndex)
				let swiftMatchRange = makeSwiftRangeForString(compareString, nsRange: theNSRange)
				tempArray.insert(swiftMatchRange, atIndex: currIndex)
			}
			
			matchList.insert(tempArray, atIndex: matchIndex)
		}
		
		matchArray = matchList
		print("matchArray = \(matchArray)")	// TODO: remove this when done with testing
	}
	
	
	// MARK: - Private Functions
	
	private func makeSwiftRangeForString(swiftString: String, nsRange: NSRange) -> Range<String.CharacterView.Index> {
		
		// TODO: add "as of version" attribute in case of future changes
		// TODO: what to do if range ends up being nil? don't want crashing!
		// NSRange was actually created using NSString (UTF-16) under the hood (as of Swift 2.2); as a result,
		//   need to convert String argument to UTF16 view to create a valid Swift String range
		let string16 = swiftString.utf16
		
		let start = nsRange.location
		let end = nsRange.location + nsRange.length
		
		let swiftRangeStart = string16.startIndex.advancedBy(start).samePositionIn(swiftString)
		let swiftRangeEnd = string16.startIndex.advancedBy(end).samePositionIn(swiftString)
		
		let swiftRange = Range(swiftRangeStart!..<swiftRangeEnd!)
		return swiftRange
	}
	
}
