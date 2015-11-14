//
//  SpeechButtonManager.swift
//  Dictater
//
//  Created by Kyle Carson on 9/11/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation
import Cocoa

class SpeechButtonManager : NSObject
{
	weak var progressView	: NSView?
	weak var playPauseButton : NSButton?
	weak var skipForwardButton : NSButton?
	weak var skipBackwardsButton : NSButton?
	weak var openTeleprompterButton : NSButton?
	weak var remainingTimeView : NSTextField?
	
	let speech : Speech
	let controls : Speech.Controls
	
	init(speech: Speech)
	{
		self.speech = speech
		self.controls = Speech.Controls(speech: speech)
		
		super.init()
	}
	
	var progressAnimation : NSAnimation?
	
	func registerEvents()
	{
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "update", name: Speech.ProgressChangedNotification, object: speech)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "update", name: Speech.TotalDurationChangedNotification, object: speech)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "update", name: Vocalization.IsSpeakingChangedNotification, object: nil)
		
		self.playPauseButton?.target = self
		self.playPauseButton?.action = "playPause"
		
		self.skipForwardButton?.target = self
		self.skipForwardButton?.action = "skipAhead"
		
		self.skipBackwardsButton?.target = self
		self.skipBackwardsButton?.action = "skipBackwards"
	}
	
	func deregisterEvents()
	{
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	func update()
	{
		self.playPauseButton?.title = self.controls.playPauseIcon
		
		self.playPauseButton?.enabled = self.controls.canPlayPause
		self.skipBackwardsButton?.enabled = self.controls.canSkipBackwards
		self.skipForwardButton?.enabled = self.controls.canSkipForward
		self.openTeleprompterButton?.enabled = self.controls.canOpenTeleprompter
		
		self.skipBackwardsButton?.menu = self.backwardsButtonMenu()
		
		if let view = self.progressView,
		let superview = view.superview
		{
			let progress = speech.progress
			let percent : CGFloat
			if progress.totalUnitCount > 0
			{
				percent = CGFloat(progress.completedUnitCount) / CGFloat(progress.totalUnitCount)
				
			} else {
				percent = 1
			}
			
			var frame = view.frame;
			frame.size.width = CGFloat(percent) * superview.frame.width
			
			view.animator().frame = frame
			
			if self.speech.vocalization == nil
			{
				view.hidden = true
			} else {
				view.hidden = false
			}
		}
		
		if let duration = self.totalDurationText,
		let view = self.remainingTimeView,
		let vocalization = self.speech.vocalization
		where !vocalization.didFinish
		{
			view.stringValue = duration
			view.hidden = false
			
			if view.alphaValue == 0
			{
				view.animator().alphaValue = 1.0
			}
		} else {
			self.remainingTimeView?.alphaValue = 0.0
		}
	}
	
	var totalDurationText : String?
	{
		guard let duration = self.speech.totalDuration else {
			return nil
		}
		guard let progressSeconds = self.speech.estimatedProgressSeconds else {
			return nil
		}
		
		let minutes = (duration - progressSeconds) / 60
		if minutes < 1
		{
			return "< 1m remaining"
		} else {
			return "\(Int(ceil(minutes)))m remaining"
		}
		
	}
	
	func backwardsButtonMenu() -> NSMenu
	{
		let menu = NSMenu();
		let restartButton = NSMenuItem(title: "Restart", action: "restart", keyEquivalent: "")
		if self.controls.canSkipBackwards
		{	
			restartButton.target = self
		}
		
		menu.addItem(restartButton)
		
		return menu
	}
	
	func restart()
	{
		self.speech.speak( self.speech.text )
	}
	
	func playPause()
	{
		self.speech.playPause()
	}
	
	func skipAhead()
	{
		self.speech.skip(by: Dictater.skipBoundary)
	}
	
	func skipBackwards()
	{
		self.speech.skip(by: .Sentence, forward: false)
	}
}