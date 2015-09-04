//
//  DictaterService.swift
//  Dictater
//
//  Created by Kyle Carson on 9/3/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation
import Cocoa

class DictaterService
{
	@objc func beginDicatation(pboard: NSPasteboard, userData: NSString, error: NSErrorPointer)
	{
		if let string = pboard.stringForType(NSStringPboardType)
		{
			Speech.sharedSpeech.speak( string )
		}
//		NSApp.hide(self)
//		NSApp.unhide(self)
	}
}