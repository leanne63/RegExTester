//
//  ViewController.swift
//  RegExTester
//
//  Created by leanne on 5/2/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
	
	// MARK: - Properties (Non-Outlets)
	
	lazy var regexModel = RegexModel()
	
	
	// MARK: - Properties (Outlets)
	
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
		
		// use keyboardWillShow to set back and forward buttons appropriately
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
	
	@IBAction func matchButtonTapped(sender: UIButton) {
		
		let haveValidStrings = validateRequiredStrings()
		
		if haveValidStrings {
			let regexOptions = ignoreCaseSwitch.on ? .CaseInsensitive : NSRegularExpressionOptions()
			let patternString = regexPatternField.text!
			let compareString = compareStringField.text!
			
			regexModel.findRegexMatchesWithPattern(patternString, compareString: compareString, regexOptions: regexOptions)
		}
		else {
			resultsTextView.textColor = UIColor.redColor()
			resultsTextView.text = "Both regular expression string AND compare text must be present!"
		}
	}
	
	
	// MARK: - Text Field Delegate Functions
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		
		textField.resignFirstResponder()
		
		return true
	}
	
	
	// MARK: - Selectors
	
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
	
	func modelDidChangeProperty() {
		
		// TODO: set up property observing for model result
//		resultsTextView.text = ""
//		if result == nil {
//			resultsTextView.textColor = UIColor.blueColor()
//			resultsTextView.text.appendContentsOf("Matches found:\n\n")
//			for match in regexModel.matchArray {
//				resultsTextView.text.appendContentsOf("\(match)\n")
//			}
//		}
//		else {
//			resultsTextView.textColor = UIColor.redColor()
//			resultsTextView.text = result
//		}
	}
	
	
	// MARK: - Private Functions
	
	private func dismissKeyboard() {
		
		// shuts down any first responders within this controller's view
		view.endEditing(true)
	}
	
	private func validateRequiredStrings() -> Bool {
		
		guard let patternString = regexPatternField.text where !patternString.isEmpty,
			  let compareString = compareStringField.text where !compareString.isEmpty else {
				return false
		}
		
		return true
	}
	
}

