//
//  ViewController.swift
//  RegExTester
//
//  Created by leanne on 5/2/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
	
	// MARK: - Properties
	
	@IBOutlet weak var ignoreCaseSwitch: UISwitch!
	@IBOutlet weak var globalSwitch: UISwitch!
	
	@IBOutlet weak var regexCodeField: UITextField!
	@IBOutlet weak var testStringField: UITextField!
	
	@IBOutlet weak var resultsTextView: UITextView!
	
	
	// MARK: - Life Cycle Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	
	// MARK: - Delegate Functions
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		
//		let newText: NSString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
//		
//		if newText.length > 5 {
//			return false
//		}
		
		return true
	}


}

