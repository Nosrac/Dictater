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
	@IBOutlet var fontButton : NSPopUpButton?
	@IBOutlet var fontSizeText : NSTextField?
	@IBOutlet var LineHeightMultipleText : NSTextField?
	
	@IBOutlet var lineHeightMultipleDecrementButton : NSButton?
	@IBOutlet var fontSizeDecrementButton : NSButton?
	
	let minLineHeightMultiple = 0.85
	let minFontSize = 10
	
	@IBAction func changeFontSize (sender: AnyObject?)
	{
		if let changeInSize = sender?.tag
		{
			Dictater.fontSize += changeInSize
			
			self.update()
		}
	}
	@IBAction func changeLineHeightMultiple (sender: AnyObject?)
	{
		if let changeInSize = sender?.tag
		{
			Dictater.lineHeightMultiple += Double(changeInSize) / 100.0
			
			self.update()
		}
	}
	
	override func viewDidLoad() {
		self.update()
		
		self.fontButton?.target = self
		self.fontButton?.action = #selector(self.saveFonts)
		
		fontButton?.removeAllItems()
		fontButton?.addItems(withTitles: NSFontManager.shared.availableFontFamilies)
		fontButton?.selectItem(withTitle: Dictater.fontName)
	}
	
	func update()
	{	
		let fontSize = Dictater.fontSize
		if fontSize > self.minFontSize
		{
			self.fontSizeDecrementButton?.isEnabled = true
		} else {
			self.fontSizeDecrementButton?.isEnabled = false
		}
		
		
		let lineHeightMultiple = Dictater.lineHeightMultiple
		if lineHeightMultiple - self.minLineHeightMultiple > 0.01
		{
			self.lineHeightMultipleDecrementButton?.isEnabled = true
		} else {
			self.lineHeightMultipleDecrementButton?.isEnabled = false
		}
		
		fontSizeText?.stringValue = "\(fontSize)pt"
		LineHeightMultipleText?.stringValue = "\(Dictater.lineHeightMultiple)x"
		
	}
	@objc func saveFonts() {
		if let fontButton = self.fontButton,
		let item = fontButton.selectedItem
		{
			Dictater.fontName = item.title
		}
	}
}
