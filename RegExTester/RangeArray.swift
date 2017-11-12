//
//  RangeArray.swift
//  RegExTester
//
//  Created by leanne on 5/18/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import Foundation

/// An array of arrays of Range<Index> values disguised as an AnyObject.
class RangeArray: Any {
	
	/// The multidimensional Range<Index> array to be wrapped as an AnyObject.
	var array: [[Range<String.Index>]]!
	
	/**
	
	Initialized an array of arrays of Range<Index> objects.
	Use this to pass NSRegularExpression results around, since Swift doesn't
	allow structs as AnyObject.
	
	- parameter: a multidimensional array of Swift ranges.
	
	- returns: the same array, now wrapped as an AnyObject value.
	
	- important: Range<Index> is shorthand for Range<String.CharacterView.Index>
	
	*/
	init(_ rangeArray: [[Range<String.Index>]]) {
		
		array = rangeArray
	}
	
}
