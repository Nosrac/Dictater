//
//  DictaterService.swift
//  Dictater
//
//  Created by Kyle Carson on 9/3/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation
import Cocoa

public class DictaterService
{
	@objc func beginDicatation(_ pboard: NSPasteboard, userData: NSString, error: NSErrorPointer)
	{
		if let string = pboard.string(forType: NSPasteboard.PasteboardType.string)
		{
			Speech.sharedSpeech.speak( text: string )
			Dictater.hasBeenUsed = true
		}
	}
}
