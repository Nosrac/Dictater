
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
	
	func windowWillEnterFullScreen(_ notification: NSNotification)
	{
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: TeleprompterWindowDelegate.FullScreenEnteredEvent), object: nil)
	}
	
	func windowDidExitFullScreen(_ notification: NSNotification)
	{
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: TeleprompterWindowDelegate.FullScreenExitedEvent), object: nil)
	}
	
	func windowDidResize(_ notification: NSNotification) {
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: TeleprompterWindowDelegate.ResizedEvent), object: nil)
	}
}
