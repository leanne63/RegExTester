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
	let matchArrayDidChange = "matchArrayDidChange"
	let messageDidChange = "messageDidChange"
	
	
	/// Holds any matches found.
	var matchArray = [String]() {
		didSet {
			NSNotificationCenter.defaultCenter().postNotificationName(matchArrayDidChange, object: matchArray)
		}
	}
	
	/// Holds any messages resulting from matching attempt.
	var message: String? {
		didSet {
			NSNotificationCenter.defaultCenter().postNotificationName(messageDidChange, object: message)
		}
	}
	
	
	// MARK: - Methods

	/**
	
	Checks for regular expression matches in a provided string.
	
	parameters:
		- regexPattern: The regular expression pattern on which to match.
		- compareString: The string in which to search for the matching pattern.
		- regexOptions: Any special pattern-matching options, such as NSRegularExpressionOptions.CaseInsensitive.
	
	returns: An explanatory message if the match failed; nil if matching was successful.
	
	*/
	func findRegexMatchesWithPattern(regexPattern: String, compareString: String, regexOptions: NSRegularExpressionOptions) {

		guard let regex = try? NSRegularExpression(pattern: regexPattern, options: regexOptions) else {
			message = "Unable to configure RegEx object with specified pattern."
			return
		}
		
		let matchingOptions: NSMatchingOptions = NSMatchingOptions()
		let searchRange = NSMakeRange(0, compareString.characters.count)
		
		let matches = regex.matchesInString(compareString, options: matchingOptions, range: searchRange)
		
		guard matches.count > 0 else {
			message = "No matches found!"
			return
		}
		
		var matchList = [String]()
		for match in matches {
			let matchStart = compareString.startIndex.advancedBy(match.range.location)
			let matchEnd = compareString.startIndex.advancedBy(match.range.location + match.range.length)
			let matchRange = Range(matchStart..<matchEnd)
			matchList.append(compareString.substringWithRange(matchRange))
		}
		
		matchArray = matchList
		
	}
	
}
