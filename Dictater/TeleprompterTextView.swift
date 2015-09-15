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
	override func keyDown(theEvent: NSEvent) {
		for char in TeleprompterTextView.skipChars
		{
			if char == theEvent.characters
			{
				return
			}
		}
		super.keyDown(theEvent)
	}
}