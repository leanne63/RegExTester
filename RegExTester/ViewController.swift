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
	
	@IBOutlet weak var regexPatternField: UITextField!
	@IBOutlet weak var compareStringField: UITextField!
	
	@IBOutlet weak var resultsTextView: UITextView!
	
	@IBOutlet var toolbar: UIToolbar!
	@IBOutlet weak var backButton: UIBarButtonItem!
	@IBOutlet weak var forwardButton: UIBarButtonItem!
	@IBOutlet weak var doneButton: UIBarButtonItem!
	
	// MARK: - Life Cycle Overrides
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		regexPatternField.delegate = self
		regexPatternField.inputAccessoryView = toolbar
		
		compareStringField.delegate = self
		compareStringField.inputAccessoryView = toolbar
		
		NSNotificationCenter.defaultCenter().addObserver(self,
		                                                 selector: #selector(keyboardWillShow(_:)),
		                                                 name: UIKeyboardWillShowNotification,
		                                                 object: nil)
		
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	
	// MARK: - Actions
	
	@IBAction func viewTapped(sender: UITapGestureRecognizer) {
		
		dismissKeyboard()
	}
	
	@IBAction func keyboardToolbarItemTapped(sender: UIBarButtonItem) {

		switch sender {
		case forwardButton:
			compareStringField.becomeFirstResponder()
			
		case backButton:
			regexPatternField.becomeFirstResponder()
			
		default:
			dismissKeyboard()
		}
	}
	
	
	// MARK: - Text Field Delegate Functions
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		
		// if both pattern and compare string are filled, begin regex
		// if pattern is filled and compare string is not, move to compare string
		// if compare string is filled and pattern is not, move to pattern
		// if neither is filled, move to the one the user did not come from
		// OR, arrows above keyboard for next and back, and return checks
		textField.resignFirstResponder()
		
		if let pattern = regexPatternField.text where !pattern.isEmpty,
		   let compareString = compareStringField.text where !compareString.isEmpty {
			
			let regexOptions = ignoreCaseSwitch.on ? .CaseInsensitive : NSRegularExpressionOptions()
			
			let regexModel = RegExModel()
			let result = regexModel.findRegexMatchesWithPattern(pattern, compareString: compareString, regexOptions: regexOptions)
			
			resultsTextView.text = ""
			if result == nil {
				resultsTextView.textColor = UIColor.blueColor()
				resultsTextView.text.appendContentsOf("Matches found:\n\n")
				for match in regexModel.matchArray {
					resultsTextView.text.appendContentsOf("\(match)\n")
				}
			}
			else {
				resultsTextView.textColor = UIColor.redColor()
				resultsTextView.text = result
			}
		}
		
		return true
	}
	
	
	// MARK: - Notification Selectors
	
	func keyboardWillShow(notification: NSNotification) {
		
		if regexPatternField.isFirstResponder() {
			forwardButton.enabled = true
			backButton.enabled = false
		}
		else if compareStringField.isFirstResponder() {
			backButton.enabled = true
			forwardButton.enabled = false
		}
	}
	
	
	// MARK: - Private Functions
	
	private func dismissKeyboard() {
		
		// shuts down any first responders within this controller's view
		view.endEditing(true)
	}
	
}

