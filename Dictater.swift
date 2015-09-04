//
//  Dictater.swift
//  Dictater
//
//  Created by Kyle Carson on 9/2/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation

class Dictater
{
	enum PreferenceKeys : String
	{
		case SkipBoundary = "skipBoundary"
	}
	
	static func setupDefaults()
	{
		NSUserDefaults.standardUserDefaults().registerDefaults(
			[
				PreferenceKeys.SkipBoundary.rawValue : Speech.Boundary.Sentence.rawValue,
			])
	}
	
	static var skipBoundary : Speech.Boundary
		{
		get {
		let rawValue = NSUserDefaults.standardUserDefaults().integerForKey(PreferenceKeys.SkipBoundary.rawValue)
		if let boundary = Speech.Boundary(rawValue: rawValue)
	{
		return boundary
		}
		return .Sentence
		}
		set {
			NSUserDefaults.standardUserDefaults().setInteger(newValue.rawValue, forKey: PreferenceKeys.SkipBoundary.rawValue)
		}
	}
	
}