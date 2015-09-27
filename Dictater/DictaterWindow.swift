//
//  DictateAssistWindow.swift
//  Dictate Assist
//
//  Created by Kyle Carson on 9/1/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation
import Cocoa

class DictaterWindow : NSWindow
{
	override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, `defer` flag: Bool) {
		super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, `defer`: flag)
		
		self.styleMask = NSBorderlessWindowMask
		self.opaque = false
		self.backgroundColor = NSColor.clearColor()
		self.level = Int(CGWindowLevelForKey(.FloatingWindowLevelKey))
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterFullScreen", name: TeleprompterWindowDelegate.FullScreenEnteredEvent, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "didExitFullScreen", name: TeleprompterWindowDelegate.FullScreenExitedEvent, object: nil)
	}
	
	func didEnterFullScreen()
	{
		self.orderOut(self)
	}
	
	func didExitFullScreen()
	{
		self.orderFront(self)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override var contentView : NSView? {
		set {
			if let view = newValue
			{
				view.wantsLayer = true
				view.layer?.frame = view.frame
				view.layer?.cornerRadius = 10.0
				view.layer?.masksToBounds = true
			}
			super.contentView = newValue
			
		}
		get {
			return super.contentView
		}
	}
	
	override var canBecomeMainWindow : Bool
		{
		get {
			return true
		}
	}
	
	override var canBecomeKeyWindow : Bool
		{
		get {
			return true
		}
	}
	
	// Drag Windows
	
	var initialLocation : NSPoint?
	
	override func mouseDown(theEvent: NSEvent) {
		initialLocation = theEvent.locationInWindow
	}
	
	override func mouseDragged(theEvent: NSEvent) {
		if let screenVisibleFrame = NSScreen.mainScreen()?.visibleFrame,
			let initialLocation = self.initialLocation
		{
			let windowFrame = self.frame
			var newOrigin = windowFrame.origin
			
			let currentLocation = theEvent.locationInWindow
			
			newOrigin.x += (currentLocation.x - initialLocation.x)
			newOrigin.y += (currentLocation.y - initialLocation.y)
			
			if (newOrigin.y + windowFrame.size.height) > (screenVisibleFrame.origin.y + screenVisibleFrame.size.height)
			{
				newOrigin.y = screenVisibleFrame.origin.y + screenVisibleFrame.size.height - windowFrame.size.height
			}
			
			self.setFrameOrigin(newOrigin)
		}
	}
}