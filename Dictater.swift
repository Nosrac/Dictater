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
		case ProgressBarEnabled = "progressBarEnabled"
		case AutoScrollEnabled = "autoScrollEnabled"
	}
	
	static let TextAppearanceChangedNotification = "Dictater.FontChanged"
	
	static func setupDefaults()
	{
		let font = self.defaultFont
		UserDefaults.standard.register(
			defaults: [
				PreferenceKeys.SkipBoundary.rawValue : Speech.Boundary.Sentence.rawValue,
				PreferenceKeys.HasBeenUsed.rawValue : false,
				PreferenceKeys.FontName.rawValue : font.fontName,
				PreferenceKeys.FontSize.rawValue : Double(font.pointSize),
				PreferenceKeys.LineHeightMultiple.rawValue : 1.2,
				PreferenceKeys.ProgressBarEnabled.rawValue : true,
				PreferenceKeys.AutoScrollEnabled.rawValue : true,
			])
	}
	
	static var skipBoundary : Speech.Boundary
	{
		get
		{
			let rawValue = UserDefaults.standard.integer(forKey: PreferenceKeys.SkipBoundary.rawValue)
			if let boundary = Speech.Boundary(rawValue: rawValue)
			{
				return boundary
			}
			return .Sentence
		}
		set
		{
			UserDefaults.standard.set(newValue.rawValue, forKey: PreferenceKeys.SkipBoundary.rawValue)
		}
	}
	
	static var hasBeenUsed : Bool
	{
		get
		{
			return UserDefaults.standard.bool(forKey: PreferenceKeys.HasBeenUsed.rawValue)
		}
		set
		{
			UserDefaults.standard.set(newValue, forKey: PreferenceKeys.HasBeenUsed.rawValue)
		}
	}
	
	static var autoScrollEnabled : Bool
		{
		get
	{
		return UserDefaults.standard.bool(forKey: PreferenceKeys.AutoScrollEnabled.rawValue)
		}
		set
	{
		UserDefaults.standard.set(newValue, forKey: PreferenceKeys.AutoScrollEnabled.rawValue)
		}
	}
	
	static var isProgressBarEnabled : Bool
	{
		get {
			return UserDefaults.standard.bool(forKey: PreferenceKeys.ProgressBarEnabled.rawValue)
		}
		set
		{
			UserDefaults.standard.set(newValue, forKey: PreferenceKeys.ProgressBarEnabled.rawValue)
		}
	}
	
	static var font : NSFont
	{
		let cgfloat = CGFloat(self.fontSize)
		return NSFont(name: self.fontName, size: cgfloat) ?? self.defaultFont
	}
	
	static var defaultFont : NSFont
	{
		return NSFont.messageFont(ofSize: 14)
	}
	
	
	static var fontName : String
	{
		get {
			if let string = UserDefaults.standard.string(forKey: PreferenceKeys.FontName.rawValue)
			{
				return string
			} else {
				return self.defaultFont.fontName
			}
		}
		
		set {
			UserDefaults.standard.set(newValue, forKey: PreferenceKeys.FontName.rawValue)
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.TextAppearanceChangedNotification), object: nil)
		}
	}
	
	static var fontSize : Int
	{
		get {
			return UserDefaults.standard.integer(forKey: PreferenceKeys.FontSize.rawValue)
		}
		
		set {
			UserDefaults.standard.set(newValue, forKey: PreferenceKeys.FontSize.rawValue)
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.TextAppearanceChangedNotification), object: nil)
		}
	}
	
	static var lineHeightMultiple : Double
	{
		get {
			return UserDefaults.standard.double(forKey: PreferenceKeys.LineHeightMultiple.rawValue)
		}
		
		set {
			UserDefaults.standard.set(newValue, forKey: PreferenceKeys.LineHeightMultiple.rawValue)
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.TextAppearanceChangedNotification), object: nil)
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
