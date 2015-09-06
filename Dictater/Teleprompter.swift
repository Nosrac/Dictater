//
//  Teleprompter.swift
//  Dictater
//
//  Created by Kyle Carson on 9/6/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation
import Cocoa

class Teleprompter : NSViewController
{
	@IBOutlet var textView : NSTextView?
	@IBOutlet var playPauseButton : NSButton?
	@IBOutlet var skipBackwardsButton : NSButton?
	@IBOutlet var skipForwardButton : NSButton?
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "update", name: Speech.ProgressChangedNotification, object: Speech.sharedSpeech)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "update", name: Vocalization.IsSpeakingChangedNotification, object: nil)
	}
	
	override func viewDidLoad() {
		self.update()
	}
	
	@IBAction func playPause(target: AnyObject?)
	{
		Speech.sharedSpeech.playPause()
	}
	
	@IBAction func skipAhead(target: AnyObject?)
	{
		Speech.sharedSpeech.skip(by: Dictater.skipBoundary)
	}
	
	@IBAction func skipBackwards(target: AnyObject?)
	{
		Speech.sharedSpeech.skip(by: .Sentence, forward: false)
	}
	
	func enableButtons()
	{
		self.playPauseButton?.enabled = Speech.Controls.sharedControls.canPlayPause
		self.skipBackwardsButton?.enabled = Speech.Controls.sharedControls.canSkipBackwards
		self.skipForwardButton?.enabled = Speech.Controls.sharedControls.canSkipForward
		
		self.playPauseButton?.title = Speech.Controls.sharedControls.playPauseIcon
	}
	
	func update()
	{
		if let textView = self.textView
		{
			if textView.string != Speech.sharedSpeech.text
			{
				textView.string = Speech.sharedSpeech.text
			}
			
			if let textStorage = textView.textStorage
			{
				textStorage.beginEditing()
				
				let fullRange = NSRange.init(location: 0, length: Speech.sharedSpeech.text.characters.count)
				for (key, _) in self.highlightAttributes
				{
					textStorage.removeAttribute(key, range: fullRange)
				}
				if let newRange = Speech.sharedSpeech.range
				{
					textStorage.addAttributes(self.highlightAttributes, range: newRange)
				}
				textStorage.endEditing()
			}
		}
		self.enableButtons()
	}
	
	let highlightAttributes : [String:AnyObject] = [
		NSBackgroundColorAttributeName: NSColor(red:1, green:0.832, blue:0.473, alpha:0.5),
		NSUnderlineColorAttributeName: NSColor(red:1, green:0.832, blue:0.473, alpha:1),
		NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleThick.rawValue
	]
}