//
//  TeleprompterPreferencesController.swift
//  Dictater
//
//  Created by Kyle Carson on 9/7/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation
import Cocoa

class TeleprompterPreferencesController : NSViewController
{
	@IBOutlet var fontButton : NSButton?
	@IBOutlet var fontSizeText : NSTextField?
	@IBOutlet var LineHeightMultipleText : NSTextField?
	
	@IBAction func changeFontSize (sender: AnyObject?)
	{
		if let changeInSize = sender?.tag()
		{
			Dictater.fontSize += Double(changeInSize)
			
			self.update()
		}
	}
	@IBAction func changeLineHeightMultiple (sender: AnyObject?)
	{
		if let changeInSize = sender?.tag()
		{
			Dictater.lineHeightMultiple += Double(changeInSize) / 100.0
			
			print(Dictater.lineHeightMultiple)
			self.update()
		}
	}
	
	override func viewDidLoad() {
		self.update()
	}
	
	func update()
	{
		let font = Dictater.font
		
		let name : String
		
		if font.fontName == NSFont.messageFontOfSize(1).fontName
		{
			name = "System Font"
		} else if let familyName = font.familyName
		{
			name = familyName
		} else {
			name = "[Unnamed]"
		}
		
		fontButton?.title = name
		fontSizeText?.stringValue = "\(Int(Dictater.fontSize))pt"
		LineHeightMultipleText?.stringValue = "\(Dictater.lineHeightMultiple)x"
	}
	
	var fontPanel : NSFontPanel?
	
	@IBAction func openFontPanel(sender: AnyObject?)
	{
		let font = Dictater.font
		NSFontManager.sharedFontManager().target = self
		NSFontManager.sharedFontManager().setSelectedFont(font, isMultiple: false)
		
		self.fontPanel = NSFontPanel.sharedFontPanel()
		let controller = NSWindowController(window: fontPanel)
		controller.showWindow(self)
	}
	
	@objc override func changeFont(sender: AnyObject?) {
	}
	
	func saveFonts() {
		if let font = NSFontManager.sharedFontManager().selectedFont
		{
			Dictater.fontName = font.fontName
			Dictater.fontSize = Double(font.pointSize)
			
			self.update()
		}
	}
	
	func changeAttributes(sender: AnyObject?) {
		self.performSelector("saveFonts", withObject: nil, afterDelay: 0.1)
	}
}