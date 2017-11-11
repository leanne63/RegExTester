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
	fileprivate let matchArrayDidChange = "matchArrayDidChange"
	fileprivate let matchArrayKey = "matchArray"
	fileprivate let messageDidChange = "messageDidChange"
	fileprivate let messageKey = "message"
	
	
	/// Holds any matches found.
	var matchArray = [[Range<String.CharacterView.Index>]]() {
		didSet {
			// using a custom class to wrap the array; since it's a struct, it can't be passed as AnyObject on its own
			let rangeArray: AnyObject = RangeArray(matchArray)
			let userInfoDict = [matchArrayKey: rangeArray]
			NotificationCenter.default.post(name: Notification.Name(rawValue: matchArrayDidChange), object: nil, userInfo: userInfoDict)
		}
	}
	
	/// Holds any messages regarding issues with matching attempt.
	var message: String? {
		didSet {
			if let message = message {
				let userInfoDict = [messageKey: message]
				NotificationCenter.default.post(name: Notification.Name(rawValue: messageDidChange), object: nil, userInfo: userInfoDict)
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
	func findRegexMatchesWithPattern(_ regexPattern: String, compareString: String, regexOptions: NSRegularExpression.Options) {

		// create regex object
		guard let regex = try? NSRegularExpression(pattern: regexPattern, options: regexOptions) else {
			let patternString = regexPattern.isEmpty ? "<empty!>" : regexPattern
			message = "Unable to configure RegEx object with specified pattern (/\(patternString)/)."
			return
		}
		
		let matchingOptions: NSRegularExpression.MatchingOptions = NSRegularExpression.MatchingOptions()
		
		// note that search range must be NSRange, even though compare string is a String (not NSString!) (as of Swift 2.2)
		// as a result, range length value must match NSString, NOT String (to allow for unicode characters such as emoji)
		let rangeLocation = 0
		let rangeLength = (compareString as NSString).length
		let searchRange = NSMakeRange(rangeLocation, rangeLength)
		
		// run the regex
		let matches = regex.matches(in: compareString, options: matchingOptions, range: searchRange)

		guard matches.count > 0 else {
			message = "No matches found!"
			return
		}
		
		// matches come as NSRange values; we want to put Swift Range values into the array, though
		var matchList = [[Range<String.CharacterView.Index>]]()
		for (outerIndex, match) in matches.enumerated() {
			let numRanges = match.numberOfRanges
			
			matchList.insert([Range<String.CharacterView.Index>](), at: outerIndex)
			
			for innerIndex in 0..<numRanges {
				let theNSRange = match.rangeAt(innerIndex)
				let swiftMatchRange = makeSwiftRangeForString(compareString, nsRange: theNSRange)
				
				matchList[outerIndex].insert(swiftMatchRange, at: innerIndex)
			}
		}
		
		matchArray = matchList
	}
	
	
	// MARK: - Private Functions
	
	fileprivate func makeSwiftRangeForString(_ swiftString: String, nsRange: NSRange) -> Range<String.CharacterView.Index> {
		
		// TODO: add "as of version" attribute in case of future changes
		// TODO: what to do if range ends up being nil? don't want crashing!
		// NSRange was actually created using NSString (UTF-16) under the hood (as of Swift 2.2); as a result,
		//   need to convert String argument to UTF16 view to create a valid Swift String range
		let string16 = swiftString.utf16
		
        let end: Int = nsRange.location + nsRange.length
		
        let swiftRangeStart = string16.startIndex.advanced(by: end).samePosition(in: swiftString)
        let swiftRangeEnd = string16.startIndex.advanced(by: end).samePosition(in: swiftString)
		
		let swiftRange = Range(swiftRangeStart!..<swiftRangeEnd!)
		return swiftRange
	}
	
}
