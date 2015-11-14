
//
//  TeleprompterDelegate.swift
//  Dictater
//
//  Created by Kyle Carson on 9/27/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation
import Cocoa

class TeleprompterWindowDelegate : NSObject, NSWindowDelegate
{
	static let FullScreenEnteredEvent = "Teleprompter.FullScreenEntered"
	static let FullScreenExitedEvent = "Teleprompter.FullScreenExited"
	static let ResizedEvent = "Teleprompter.Resized"
	
	func windowWillEnterFullScreen(notification: NSNotification)
	{
		NSNotificationCenter.defaultCenter().postNotificationName(TeleprompterWindowDelegate.FullScreenEnteredEvent, object: nil)
	}
	
	func windowDidExitFullScreen(notification: NSNotification)
	{
		NSNotificationCenter.defaultCenter().postNotificationName(TeleprompterWindowDelegate.FullScreenExitedEvent, object: nil)
	}
	
	func windowDidResize(notification: NSNotification) {
		NSNotificationCenter.defaultCenter().postNotificationName(TeleprompterWindowDelegate.ResizedEvent, object: nil)
	}
}