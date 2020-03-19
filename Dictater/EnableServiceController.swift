//
//  EnableServiceController.swift
//  Dictater
//
//  Created by Kyle Carson on 9/4/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation
import Cocoa

class EnableServiceController : NSViewController
{
	@IBAction func openKeyboardSettings(sender: AnyObject?)
	{
		NSWorkspace.shared.openFile("/System/Library/PreferencePanes/Keyboard.prefPane")
	}
}
