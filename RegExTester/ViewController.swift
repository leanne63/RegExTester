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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		regexPatternField.delegate = self
		regexPatternField.inputAccessoryView = toolbar
		
		compareStringField.delegate = self
		compareStringField.inputAccessoryView = toolbar
		
		subscribeToStuff()
	}
	
	deinit {
		// unsubscribe from everything
		NotificationCenter.default.removeObserver(self)
	}

	
	// MARK: - Actions
	
	@IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
		
		dismissKeyboard()
	}
	
	@IBAction func keyboardToolbarItemTapped(_ sender: UIBarButtonItem) {

		switch sender {
		case forwardButton:
			compareStringField.becomeFirstResponder()
			
		case backButton:
			regexPatternField.becomeFirstResponder()
			
		default:
			dismissKeyboard()
		}
	}
	
	@IBAction func matchButtonTapped(_ sender: UIButton) {
		
		dismissKeyboard()
		resultsTextView.text = nil
		
		let haveValidStrings = validateRequiredStrings()
		
		if haveValidStrings {
			let regexOptions = ignoreCaseSwitch.isOn ? .caseInsensitive : NSRegularExpression.Options()
			let patternString = regexPatternField.text!
			let compareString = compareStringField.text!
			
			let regexModel = RegexModel()
			regexModel.findRegexMatchesWithPattern(patternString, compareString: compareString, regexOptions: regexOptions)
		}
		else {
			resultsTextView.textColor = UIColor.red
			resultsTextView.text = "Regular expression string required!"
		}
	}
	
	
	// MARK: - Text Field Delegate Functions
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		textField.resignFirstResponder()
		
		return true
	}
	
	
	// MARK: - Selectors
	
	@objc func keyboardWillShow(_ notification: Notification) {
		
		if regexPatternField.isFirstResponder {
			forwardButton.isEnabled = true
			backButton.isEnabled = false
		}
		else if compareStringField.isFirstResponder {
			backButton.isEnabled = true
			forwardButton.isEnabled = false
		}
	}
	
	@objc func regexMatchDidComplete(_ notification: Notification) {
		
		let arrayChangedNotification = Notification.Name("matchArrayDidChange")
		let matchArrayKey = "matchArray"
		let compareString = compareStringField.text!

		resultsTextView.text = ""
		if notification.name == arrayChangedNotification {
			resultsTextView.textColor = UIColor.blue
			resultsTextView.text.append("Matches found:\n\n")
			
			let rangeArrayObject = notification.userInfo![matchArrayKey] as! RangeArray
			let matchArray: [[Range<String.Index>]] = rangeArrayObject.array
			
			var resultsText = ""
			for matchArrayItem in matchArray {
				for (idx, currItem) in matchArrayItem.enumerated() {
					resultsText += (idx == 0) ? "Main match: " : "Group match: "
					
					let matchString = compareString[currItem.lowerBound..<currItem.upperBound]
					
					resultsText += "\(matchString)\n"
				}
				resultsText += "\n"
			}
			resultsTextView.text = resultsText
		}
		else {
			resultsTextView.textColor = UIColor.red
			let message = notification.userInfo?["message"] as! String
			resultsTextView.text = message
		}
	}
	
	
	// MARK: - Private Functions
	
	/// Hides keyboard
	fileprivate func dismissKeyboard() {
		
		// shuts down any first responders within this controller's view
		view.endEditing(true)
	}
	
	
	/**
	
	Ensures strings meet requirements (eg, not empty or nil)
	
	returns: True if string requirements are met.
	
	*/
	fileprivate func validateRequiredStrings() -> Bool {
		
		guard compareStringField.text != nil,
			  let patternString = regexPatternField.text, !patternString.isEmpty else {
			return false
		}
		
		return true
	}
	
	fileprivate func subscribeToStuff() {
		
		NotificationCenter.default.addObserver(self,
		                                                 selector: #selector(keyboardWillShow(_:)),
		                                                 name: NSNotification.Name.UIKeyboardWillShow,
		                                                 object: nil)
		
		NotificationCenter.default.addObserver(self,
		                                                 selector: #selector(regexMatchDidComplete(_:)),
		                                                 name: NSNotification.Name(rawValue: "matchArrayDidChange"),
		                                                 object: nil)
		
		NotificationCenter.default.addObserver(self,
		                                                 selector: #selector(regexMatchDidComplete(_:)),
		                                                 name: NSNotification.Name(rawValue: "messageDidChange"),
		                                                 object: nil)
	}
	
	
}

