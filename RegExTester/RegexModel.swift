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
	private let messageDidChange = "messageDidChange"
	
	
	/// Holds any matches found.
	var matchArray = [[Range<String.CharacterView.Index>]]() {
		didSet {
			NSNotificationCenter.defaultCenter().postNotificationName(matchArrayDidChange, object: matchArray as? AnyObject)
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
	
	*/
	func findRegexMatchesWithPattern(regexPattern: String, compareString: String, regexOptions: NSRegularExpressionOptions) {

		// create regex
		guard let regex = try? NSRegularExpression(pattern: regexPattern, options: regexOptions) else {
			let patternString = regexPattern.isEmpty ? "<empty!>" : regexPattern
			message = "Unable to configure RegEx object with specified pattern (/\(patternString)/)."
			return
		}
		
		let matchingOptions: NSMatchingOptions = NSMatchingOptions()
		let searchRange = NSMakeRange(0, compareString.characters.count)
		
		// run the regex
		let matches = regex.matchesInString(compareString, options: matchingOptions, range: searchRange)

		guard matches.count > 0 else {
			message = "No matches found!"
			return
		}
		
		// convert match NSRange objects to Swift Range objects; add them to the match array
		var matchList = [[Range<String.CharacterView.Index>]]()
		for (matchIndex, match) in matches.enumerate() {
			var tempArray = [Range<String.CharacterView.Index>]()
			
			let matchRange0 = makeSwiftRangeForString(compareString, nsRange: match.range)
			tempArray.insert(matchRange0, atIndex: 0)

			let numRanges = match.numberOfRanges
			
			for groupIndex in 1..<numRanges where numRanges > 1 {
				let groupMatchRange = makeSwiftRangeForString(compareString, nsRange: match.rangeAtIndex(groupIndex))
				tempArray.insert(groupMatchRange, atIndex: groupIndex)
			}
			
			matchList.insert(tempArray, atIndex: matchIndex)
		}
		
		matchArray = matchList
		print("matchArray = \(matchArray)")	// TODO: remove this when done with testing
	}
	
	
	// MARK: - Private Functions
	
	private func makeSwiftRangeForString(string: String, nsRange: NSRange) -> Range<String.CharacterView.Index> {
		
		let swiftRangeStart = string.startIndex.advancedBy(nsRange.location)
		let swiftRangeEnd = string.startIndex.advancedBy(nsRange.location + nsRange.length)
		
		let swiftRange = Range(swiftRangeStart..<swiftRangeEnd)
		return swiftRange
	}
	
}
