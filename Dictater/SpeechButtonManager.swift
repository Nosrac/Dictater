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
	weak var progressIndicator	: NSProgressIndicator?
	weak var playPauseButton : NSButton?
	weak var skipForwardButton : NSButton?
	weak var skipBackwardsButton : NSButton?
	weak var openTeleprompterButton : NSButton?
	
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
		
		if let view = self.progressIndicator
		{
			self.progressAnimation?.stopAnimation()
			
			let progress = speech.progress
			if progress.totalUnitCount > 0
			{
				view.maxValue = Double(progress.totalUnitCount)
				self.progressAnimation = view.animateToDoubleValue( Double(progress.completedUnitCount) )
			} else {
				view.maxValue = 1
				self.progressAnimation = view.animateToDoubleValue( 1.0 )
			}
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