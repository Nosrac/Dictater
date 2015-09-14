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
		if let changeInSize = sender?.tag()
		{
			Dictater.fontSize += changeInSize
			
			self.update()
		}
	}
	@IBAction func changeLineHeightMultiple (sender: AnyObject?)
	{
		if let changeInSize = sender?.tag()
		{
			Dictater.lineHeightMultiple += Double(changeInSize) / 100.0
			
			self.update()
		}
	}
	
	override func viewDidLoad() {
		self.update()
		
		self.fontButton?.target = self
		self.fontButton?.action = "saveFonts"
		
		fontButton?.removeAllItems()
		fontButton?.addItemsWithTitles(NSFontManager.sharedFontManager().availableFontFamilies)
	}
	
	var fontMenu : NSMenu
	{
		let menu = NSMenu()
		
		for font in NSFontManager.sharedFontManager().availableFontFamilies
		{
			let item = NSMenuItem(title: font, action: "saveFonts", keyEquivalent: "")
			item.attributedTitle = NSAttributedString(string: font, attributes: [
				NSFontAttributeName : font
				])
			item.target = self
			
			menu.addItem(item)
		}
		
		return menu
	}
	
	func update()
	{
		fontButton?.selectItemWithTitle(Dictater.fontName)
		
		let fontSize = Dictater.fontSize
		if fontSize > self.minFontSize
		{
			self.fontSizeDecrementButton?.enabled = true
		} else {
			self.fontSizeDecrementButton?.enabled = false
		}
		
		
		let lineHeightMultiple = Dictater.lineHeightMultiple
		if lineHeightMultiple - self.minLineHeightMultiple > 0.01
		{
			self.lineHeightMultipleDecrementButton?.enabled = true
		} else {
			self.lineHeightMultipleDecrementButton?.enabled = false
		}
		
		fontSizeText?.stringValue = "\(fontSize)pt"
		LineHeightMultipleText?.stringValue = "\(Dictater.lineHeightMultiple)x"
		
	}
	func saveFonts() {
		if let fontButton = self.fontButton,
		let item = fontButton.selectedItem
		{
			Dictater.fontName = item.title
		}
	}
}