//
//  Dictater.swift
//  Dictater
//
//  Created by Kyle Carson on 9/2/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation
import Cocoa

class Dictater
{
	enum PreferenceKeys : String
	{
		case SkipBoundary = "skipBoundary"
		case HasBeenUsed = "hasBeenUsed"
		case FontName = "fontName"
		case FontSize = "fontSize"
		case LineHeightMultiple = "lineHeightMultiple"
	}
	
	static let TextAppearanceChangedNotification = "Dictater.FontChanged"
	
	static func setupDefaults()
	{
		let font = self.defaultFont
		NSUserDefaults.standardUserDefaults().registerDefaults(
			[
				PreferenceKeys.SkipBoundary.rawValue : Speech.Boundary.Sentence.rawValue,
				PreferenceKeys.HasBeenUsed.rawValue : false,
				PreferenceKeys.FontName.rawValue : font.fontName,
				PreferenceKeys.FontSize.rawValue : Double(font.pointSize),
				PreferenceKeys.LineHeightMultiple.rawValue : 1.2,
			])
	}
	
	static var skipBoundary : Speech.Boundary
	{
		get
		{
			let rawValue = NSUserDefaults.standardUserDefaults().integerForKey(PreferenceKeys.SkipBoundary.rawValue)
			if let boundary = Speech.Boundary(rawValue: rawValue)
			{
				return boundary
			}
			return .Sentence
		}
		set
		{
			NSUserDefaults.standardUserDefaults().setInteger(newValue.rawValue, forKey: PreferenceKeys.SkipBoundary.rawValue)
		}
	}
	
	static var hasBeenUsed : Bool
	{
		get
		{
			return NSUserDefaults.standardUserDefaults().boolForKey(PreferenceKeys.HasBeenUsed.rawValue)
		}
		set
		{
			NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: PreferenceKeys.HasBeenUsed.rawValue)
			
		}
	}
	
	static var font : NSFont
	{
		let cgfloat = CGFloat(self.fontSize)
		return NSFont(name: self.fontName, size: cgfloat) ?? self.defaultFont
		
	}
	
	static var defaultFont : NSFont
	{
		return NSFont.messageFontOfSize(14)
	}
	
	
	static var fontName : String
	{
		get {
			if let string = NSUserDefaults.standardUserDefaults().stringForKey(PreferenceKeys.FontName.rawValue)
			{
				return string
			} else {
				return self.defaultFont.fontName
			}
		}
		
		set {
			NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: PreferenceKeys.FontName.rawValue)
			NSNotificationCenter.defaultCenter().postNotificationName(self.TextAppearanceChangedNotification, object: nil)
		}
	}
	
	static var fontSize : Double
	{
		get {
			return NSUserDefaults.standardUserDefaults().doubleForKey(PreferenceKeys.FontSize.rawValue)
		}
		
		set {
			NSUserDefaults.standardUserDefaults().setDouble(newValue, forKey: PreferenceKeys.FontSize.rawValue)
			NSNotificationCenter.defaultCenter().postNotificationName(self.TextAppearanceChangedNotification, object: nil)
		}
	}
	
	static var lineHeightMultiple : Double
	{
		get {
			return NSUserDefaults.standardUserDefaults().doubleForKey(PreferenceKeys.LineHeightMultiple.rawValue)
		}
		
		set {
			NSUserDefaults.standardUserDefaults().setDouble(newValue, forKey: PreferenceKeys.LineHeightMultiple.rawValue)
			NSNotificationCenter.defaultCenter().postNotificationName(self.TextAppearanceChangedNotification, object: nil)
		}
	}
	
	class ParagraphStyle : NSParagraphStyle
	{
		let multiple = Dictater.lineHeightMultiple
		override var lineHeightMultiple : CGFloat
		{
			return CGFloat(self.multiple)
		}
	}
	
}