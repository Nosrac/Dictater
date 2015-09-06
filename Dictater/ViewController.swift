//
//  ViewController.swift
//  Dictate Assist
//
//  Created by Kyle Carson on 9/1/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	
	@IBOutlet var skipDurationMenuItem : NSMenuItem?
	
	@IBOutlet var progressIndicator	: NSProgressIndicator?
	@IBOutlet var playPauseButton : NSButton?
	@IBOutlet var skipForwardButton : NSButton?
	@IBOutlet var skipBackwardsButton : NSButton?
	@IBOutlet var openTeleprompterButton : NSButton?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupSkipDurationMenuItem()
		self.update()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "update", name: Speech.ProgressChangedNotification, object: Speech.sharedSpeech)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "update", name: Vocalization.IsSpeakingChangedNotification, object: nil)
	}
	
	func update()
	{
		self.playPauseButton?.title = Speech.Controls.sharedControls.playPauseIcon

		self.playPauseButton?.enabled = Speech.Controls.sharedControls.canPlayPause
		self.skipBackwardsButton?.enabled = Speech.Controls.sharedControls.canSkipBackwards
		self.skipForwardButton?.enabled = Speech.Controls.sharedControls.canSkipForward
		self.openTeleprompterButton?.enabled = Speech.Controls.sharedControls.canOpenTeleprompter
		
		if let view = self.progressIndicator
		{
			let progress = Speech.sharedSpeech.progress
			
			view.maxValue = Double(progress.totalUnitCount)
			view.animateToDoubleValue( Double(progress.completedUnitCount) )
		}
	}
	
	@IBAction func playPause(target: AnyObject?)
	{
		Speech.sharedSpeech.playPause()
	}
	
	@IBAction func skipAhead(target: AnyObject?)
	{
		Speech.sharedSpeech.skip(by: Dictater.skipBoundary)
	}
	
	@IBAction func skipBackwards(target: AnyObject?)
	{
		Speech.sharedSpeech.skip(by: .Sentence, forward: false)
	}
	
	@IBAction func openSpeechPreferences(target: AnyObject?)
	{
		NSWorkspace.sharedWorkspace().openFile("/System/Library/PreferencePanes/Speech.prefPane")
	}
	
	@IBAction func openMenu(target: AnyObject?)
	{
		if let menu = target?.menu,
			let view = target as? NSView
		{
			menu?.popUpMenuPositioningItem(nil, atLocation: view.frame.origin, inView: view.superview)
		}
	}
	
	// Skip Duration Settings
	
	func setupSkipDurationMenuItem()
	{
		if let item = self.skipDurationMenuItem
		{
			let boundary = Dictater.skipBoundary
			
			if let submenu = item.submenu
			{
				for child in submenu.itemArray
				{
					if child.tag == boundary.rawValue
					{
						child.state = NSOnState
					} else {
						child.state = NSOffState
					}
				}
			}
		}
	}
	
	@IBAction func changeSkipDuration(target: AnyObject?)
	{
		if let view = target as? NSMenuItem
		{
			if let boundary = Speech.Boundary(rawValue: view.tag)
			{
				Dictater.skipBoundary = boundary
				
				self.setupSkipDurationMenuItem()
			}
		}
	}
	
}

