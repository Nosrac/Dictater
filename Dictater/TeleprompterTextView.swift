//
//  TeleprompterTextView.swift
//  Dictater
//
//  Created by Kyle Carson on 9/15/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation
import Cocoa

class TeleprompterTextView : NSTextView
{
	static let skipChars = [ " " ]
	
	override func keyDown(with event: NSEvent) {
		for char in TeleprompterTextView.skipChars
		{
			if char == event.characters
			{
				self.nextKeyView?.keyDown(with: event)
				return
			}
		}
		super.keyDown(with: event)
	}
	
	var scrollDate : NSDate?
	
	override func scrollWheel(with event: NSEvent)
	{
		super.scrollWheel(with: event)
		self.scrollDate = NSDate()
	}
}
