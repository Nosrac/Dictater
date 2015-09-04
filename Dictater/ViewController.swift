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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupSkipDurationMenuItem()
		self.enableButtons()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProgress", name: Speech.ProgressChangedNotification, object: Speech.sharedSpeech)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "updatePlayPauseIcon", name: Vocalization.IsSpeakingChangedNotification, object: nil)
	}
	
	func updateProgress()
	{
		if let view = self.progressIndicator
		{
			let progress = Speech.sharedSpeech.progress
			
			view.maxValue = Double(progress.totalUnitCount)
			view.animateToDoubleValue( Double(progress.completedUnitCount) )
		}
	}
	
	static let PauseIcon = ""
	static let PlayIcon = ""
	
	func updatePlayPauseIcon()
	{
		if let view = self.playPauseButton,
		let vocalization = Speech.sharedSpeech.vocalization
		{
			if vocalization.isSpeaking
			{
				view.title = ViewController.PauseIcon
			} else {
				view.title = ViewController.PlayIcon
			}
		}
		self.enableButtons()
	}
	
	func enableButtons()
	{
		var playPauseEnabled = true
		var skipForwardEnabled = true
		
		if let vocalization = Speech.sharedSpeech.vocalization
		{
			if vocalization.didFinish
			{
				skipForwardEnabled = false
			}
		} else {
			playPauseEnabled = false
			skipForwardEnabled = false
		}
		
		self.playPauseButton?.enabled = playPauseEnabled
		self.skipBackwardsButton?.enabled = playPauseEnabled
		
		self.skipForwardButton?.enabled = skipForwardEnabled
	}
	
	@IBAction func playPause(target: AnyObject?)
	{
		Speech.sharedSpeech.playPause()
	}
	
	@IBAction func openMenu(target: AnyObject?)
	{
		if let menu = target?.menu,
		let view = target as? NSView
		{
			menu?.popUpMenuPositioningItem(nil, atLocation: view.frame.origin, inView: view.superview)
		}
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

