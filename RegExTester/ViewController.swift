//
//  ViewController.swift
//  RegExTester
//
//  Created by leanne on 5/2/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
	
	// MARK: - Properties (Outlets)
	
	@IBOutlet weak var ignoreCaseSwitch: UISwitch!
	
	@IBOutlet weak var regexPatternField: UITextField!
	@IBOutlet weak var compareStringField: UITextField!
	
	@IBOutlet weak var resultsTextView: UITextView!
	
	@IBOutlet weak var toolbar: UIToolbar!
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
		
		subscribeToStuff()
	}
	
	deinit {
		// unsubscribe from everything
		NSNotificationCenter.defaultCenter().removeObserver(self)
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
		
		dismissKeyboard()
		resultsTextView.text = nil
		
		let haveValidStrings = validateRequiredStrings()
		
		if haveValidStrings {
			let regexOptions = ignoreCaseSwitch.on ? .CaseInsensitive : NSRegularExpressionOptions()
			let patternString = regexPatternField.text!
			let compareString = compareStringField.text!
			
			let regexModel = RegexModel()
			regexModel.findRegexMatchesWithPattern(patternString, compareString: compareString, regexOptions: regexOptions)
		}
		else {
			resultsTextView.textColor = UIColor.redColor()
			resultsTextView.text = "Regular expression string required!"
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
	
	func regexMatchDidComplete(notification: NSNotification) {
		
		resultsTextView.text = ""
		if notification.name == "matchArrayDidChange" {
			resultsTextView.textColor = UIColor.blueColor()
			resultsTextView.text.appendContentsOf("Matches found:\n\n")
			let matchArray = notification.object as! [String]
			for match in matchArray {
				resultsTextView.text.appendContentsOf("\(match)\n")
			}
		}
		else {
			resultsTextView.textColor = UIColor.redColor()
			let message = notification.object as! String
			resultsTextView.text = message
		}
	}
	
	
	// MARK: - Private Functions
	
	
	/// Hides keyboard
	private func dismissKeyboard() {
		
		// shuts down any first responders within this controller's view
		view.endEditing(true)
	}
	
	
	/**
	
	Ensures strings meet requirements (eg, not empty or nil)
	
	returns: True if string requirements are met.
	
	*/
	private func validateRequiredStrings() -> Bool {
		
		guard compareStringField.text != nil,
			  let patternString = regexPatternField.text where !patternString.isEmpty else {
			return false
		}
		
		return true
	}
	
	private func subscribeToStuff() {
		
		NSNotificationCenter.defaultCenter().addObserver(self,
		                                                 selector: #selector(keyboardWillShow(_:)),
		                                                 name: UIKeyboardWillShowNotification,
		                                                 object: nil)
		
		NSNotificationCenter.defaultCenter().addObserver(self,
		                                                 selector: #selector(regexMatchDidComplete(_:)),
		                                                 name: "matchArrayDidChange",
		                                                 object: nil)
		
		NSNotificationCenter.defaultCenter().addObserver(self,
		                                                 selector: #selector(regexMatchDidComplete(_:)),
		                                                 name: "messageDidChange",
		                                                 object: nil)
	}
	
}

