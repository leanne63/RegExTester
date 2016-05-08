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
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		regexCodeField.delegate = self
		testStringField.delegate = self
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	
	// MARK: - Actions
	
	@IBAction func viewTapped(sender: UITapGestureRecognizer) {
		
		// send "fake" textfield
		textFieldShouldReturn(UITextField())
	}
	
	
	// MARK: - Delegate Functions
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		
		switch textField {
		case regexCodeField:
			regexCodeField.resignFirstResponder()
			if let stringText = testStringField.text
				where !stringText.isEmpty {
				// do regex matching
			}
			else {
				testStringField.becomeFirstResponder()
			}
			
			testStringField.becomeFirstResponder()
			
		case testStringField:
			testStringField.resignFirstResponder()
			if let regexPattern = regexCodeField.text
				where !regexPattern.isEmpty {
				// do regex matching
			}
			else {
				regexCodeField.becomeFirstResponder()
			}
			
		default:
			// shuts down any first responders within this controller's view
			view.endEditing(true)
		}
		
		return true
	}
}

