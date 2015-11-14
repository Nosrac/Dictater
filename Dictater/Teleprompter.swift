//
//  Teleprompter.swift
//  Dictater
//
//  Created by Kyle Carson on 9/6/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation
import Cocoa

class Teleprompter : NSViewController, NSWindowDelegate
{
	@IBOutlet var textView : TeleprompterTextView?
	@IBOutlet var playPauseButton : NSButton?
	@IBOutlet var skipBackwardsButton : NSButton?
	@IBOutlet var skipForwardButton : NSButton?
	@IBOutlet var progressView : NSView?
	@IBOutlet var remainingTimeView : NSTextField?
	
	let windowDelegate : NSWindowDelegate = TeleprompterWindowDelegate()
	
	let speech = Speech.sharedSpeech
	let buttonController = SpeechButtonManager(speech: Speech.sharedSpeech)
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.buttonController.progressView = self.progressView
		self.buttonController.playPauseButton = self.playPauseButton
		self.buttonController.skipForwardButton = self.skipForwardButton
		self.buttonController.skipBackwardsButton = self.skipBackwardsButton
		self.buttonController.remainingTimeView = self.remainingTimeView
		
		self.buttonController.update()
	}
	
	override func viewWillAppear() {
		
		
		self.view.window?.delegate = self.windowDelegate
		
		self.buttonController.registerEvents()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateFont", name: Dictater.TextAppearanceChangedNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "update", name: Speech.ProgressChangedNotification, object: self.speech)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateButtons", name: TeleprompterWindowDelegate.ResizedEvent, object: nil)
		
		
		self.update()
		self.updateFont()
	}
	
	override func viewWillDisappear() {
		NSNotificationCenter.defaultCenter().removeObserver(self)
		
		self.buttonController.deregisterEvents()
	}
	
	func updateFont() {
		if let textView = self.textView
		{
			textView.font = Dictater.font
			let paragraphStyle = Dictater.ParagraphStyle()
			textView.defaultParagraphStyle = paragraphStyle
			
			let range = NSMakeRange(0, textView.attributedString().length)
			textView.textStorage?.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
		}
	}
	
	func updateButtons()
	{
		self.buttonController.update()
	}
	
	func update()
	{
		if let textView = self.textView
		{
			if textView.string != self.speech.text
			{
				textView.string = self.speech.text
			}
			
			self.highlightText()
			
			if let range = self.speech.range
			where self.shouldAutoScroll()
			{
				textView.scrollRangeToVisible(range, smart: true)
			}
		}
	}
	
	func shouldAutoScroll() -> Bool
	{
		if !Dictater.autoScrollEnabled
		{
			return false
		}
		
		if let date = self.textView?.scrollDate
		{
			let seconds = NSDate().timeIntervalSinceDate(date)
			
			if seconds <= 3
			{
				return false
			}
		}
		
		return true
	}
	
	func highlightText()
	{
		if let textView = self.textView,
		let textStorage = textView.textStorage,
		newRange = self.speech.range
		{
			textStorage.beginEditing()
			
			let fullRange = NSRange.init(location: 0, length: self.speech.text.characters.count)
			for (key, _) in self.highlightAttributes
			{
				textStorage.removeAttribute(key, range: fullRange)
			}
			
			textStorage.addAttributes(self.highlightAttributes, range: newRange)
			textStorage.endEditing()
		}
	}
	
	var highlightAttributes : [String:AnyObject] {
		let attributes : [String:AnyObject] = [
			NSBackgroundColorAttributeName: NSColor(red:1, green:0.832, blue:0.473, alpha:0.5),
			NSUnderlineColorAttributeName: NSColor(red:1, green:0.832, blue:0.473, alpha:1),
			NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleThick.rawValue
		]
		return attributes
	}
}