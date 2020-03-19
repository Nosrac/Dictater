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
	override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
		super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
		
//		self.styleMask = NSBorderlessWindowMask
		self.isOpaque = false
		self.backgroundColor = NSColor.clear
		self.level = NSWindow.Level.floating
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterFullScreen), name: NSNotification.Name(rawValue: TeleprompterWindowDelegate.FullScreenEnteredEvent), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.didExitFullScreen), name: NSNotification.Name(rawValue: TeleprompterWindowDelegate.FullScreenExitedEvent), object: nil)
	}
	
	@objc func didEnterFullScreen()
	{
		self.orderOut(self)
	}
	
	@objc func didExitFullScreen()
	{
		self.orderFront(self)
	}

//	required init?(coder: NSCoder) {
//		super.init(coder: coder)
//	}
	
	override var contentView : NSView? {
		set {
			if let view = newValue
			{
				view.wantsLayer = true
				view.layer?.frame = view.frame
				view.layer?.cornerRadius = 6.0
				view.layer?.masksToBounds = true
			}
			super.contentView = newValue
			
		}
		get {
			return super.contentView
		}
	}
	
	override var canBecomeMain : Bool
		{
		get {
			return true
		}
	}
	
	override var canBecomeKey : Bool
		{
		get {
			return true
		}
	}
	
	// Drag Windows
	
	var initialLocation : NSPoint?
	
	override func mouseDown(with event: NSEvent) {
		initialLocation = event.locationInWindow
	}
	
	override func mouseDragged(with event: NSEvent) {
		if let screenVisibleFrame = NSScreen.main?.visibleFrame,
			let initialLocation = self.initialLocation
		{
			let windowFrame = self.frame
			var newOrigin = windowFrame.origin
			
			let currentLocation = event.locationInWindow
			
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
