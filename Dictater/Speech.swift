//
//  Speech.siwft.swift
//  Dictater
//
//  Created by Kyle Carson on 9/4/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation
import Cocoa

class Speech
{
	class Controls
	{
		let speech : Speech
		
		init(speech: Speech)
		{
			self.speech = speech
		}
		
		static let PauseIcon = ""
		static let PlayIcon = ""
		
		var canPlayPause : Bool
		{
			if let _ = Speech.sharedSpeech.vocalization
			{
				return true
			} else {
				return false
			}
		}
		
		var playPauseIcon : String
		{
			if let vocalization = self.speech.vocalization
			where vocalization.isSpeaking
			{
				return Controls.PauseIcon
			} else {
				return Controls.PlayIcon
			}
		}
		
		var canSkipForward : Bool
		{
			guard let vocalization = Speech.sharedSpeech.vocalization else {
				return false
			}
			
			if vocalization.didFinish
			{
				return false
			} else {
				return true
			}
		}
		
		var canSkipBackwards : Bool
		{
			if let _ = Speech.sharedSpeech.vocalization
			{
				return true
			} else {
				return false
			}
		}
		
		var canOpenTeleprompter : Bool
		{
			if let _ = Speech.sharedSpeech.vocalization
			{
				return true
			} else {
				return false
			}
		}
		
		static var sharedControls : Controls
		{
			return Controls(speech: Speech.sharedSpeech)
		}
	}
	
	static var sharedSpeech : Speech =
	{
		return Speech()
	}()
	
	var text = ""
	
	var vocalization : Vocalization?
	var totalDuration : NSTimeInterval?
	{
		didSet {
			NSNotificationCenter.defaultCenter().postNotificationName(Speech.TotalDurationChangedNotification, object: self)
		}
	}
	
	var estimatedProgressSeconds : NSTimeInterval?
	{
		guard let totalDuration = self.totalDuration else {
			return nil
		}
		
		let progress = self.progress
		
		return Double(progress.completedUnitCount) / Double(progress.totalUnitCount) * totalDuration
	}
	
	func speak(text : String)
	{
		self.totalDuration = nil
		self.text = text
		self.speak(fromIndex: 0)
		
		if let vocalization = self.vocalization
		{
			vocalization.synthesizer.getSpeechDuration(self.text)
			{ (duration) in
				self.totalDuration = duration
			}
		}
	}
	
	enum Boundary : Int
	{
		case Sentence = 1
		case Paragraph = 100
		
		var name : String {
			if self == .Sentence
			{
				return "Sentence"
			} else {
				return "Paragraph"
			}
		}
		
		var enumerationOption : NSStringEnumerationOptions
		{
			if self == .Sentence
			{
				return .BySentences
			} else {
				return .ByParagraphs
			}
		}
	}
	
	static let ProgressChangedNotification = "Speech.ProgressChangedNotification"
	static let TotalDurationChangedNotification = "Speech.TotalDurationChangedNotification"
	
	var progress : NSProgress
	{
		let progress = NSProgress()
		if let range = self.range
		{
			progress.totalUnitCount = Int64(text.characters.count)
			progress.completedUnitCount = Int64(range.location)
		}
		return progress
	}
	
	var range : NSRange?
	{
		get {
			
			if let vocalization = vocalization,
			let currentRange = vocalization.currentRange
			{
				return NSRange(
					location: currentRange.location + self.skipOffset,
					length: currentRange.length
				)
			} else {
				return nil
			}
		}
	}
	private var skipOffset : Int = 0
	
	
	@objc func progressDidChange()
	{
		NSNotificationCenter.defaultCenter().postNotificationName(Speech.ProgressChangedNotification, object: self)
	}
	
	private func speak(fromIndex index: Int)
	{
		if let vocalization = self.vocalization
		{
			NSNotificationCenter.defaultCenter().removeObserver(self, name: Vocalization.ProgressChangedNotification, object: vocalization)
			
			vocalization.pause()
			self.vocalization = nil
		}
		
		var effectiveIndex = index
		
		if (effectiveIndex < 0)
		{
			effectiveIndex = 0
		}
		
		let vocalization : Vocalization
		let nsstring = NSString(string: self.text).substringFromIndex(effectiveIndex)
		
		vocalization = Vocalization( String(nsstring) )
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "progressDidChange", name: Vocalization.ProgressChangedNotification, object: vocalization)
		
		self.vocalization = vocalization
		self.skipOffset = index
		
		vocalization.start()
	}
	
	func playPause()
	{
		if let vocalization = vocalization
		{
			if vocalization.isSpeaking
			{
				self.pause()
			} else {
				self.play()
			}
		}
	}
	
	func pause()
	{
		if let vocalization = vocalization
		{
			if vocalization.isSpeaking
			{
				vocalization.pause()
			}
		}
	}
	
	func play()
	{
		if let vocalization = vocalization
		{
			if !vocalization.isSpeaking
			{
				if vocalization.didFinish
				{
					self.speak(fromIndex: 0)
				} else {
					vocalization.continueSpeaking()
				}
			}
		}
	}
	
	func skip(by boundary: Speech.Boundary, forward: Bool = true)
	{
		var options = boundary.enumerationOption
		let currentRange = self.range ?? NSRange()
		let currentLocation = currentRange.location
		
		let vocalization = self.vocalization
		
		let range : NSRange
		var index : Int?
		var skip : Bool = true
		
		let paused : Bool
		if let vocalization = vocalization
		{
			paused = !vocalization.isSpeaking
		} else {
			paused = false
		}
		
		if forward
		{
			range = NSRange(location: currentLocation, length: self.text.characters.count - currentLocation)
		} else {
			options.unionInPlace(.Reverse)
			
			range = NSRange(location: 0, length: currentLocation)
		}
			
		NSString(string: self.text).enumerateSubstringsInRange(range, options: options, usingBlock: { (substring, substringRange, enclosingRange, stop) -> Void in
			guard let substring = substring
			where substring.characters.count > 0 else {
				return
			}
			
			if let _ = index
			{
				return
			}
			
			if skip
			{
				skip = false
				
				return
			}
			
			index = substringRange.location
		})
		
		if index == nil
		{
			if forward
			{
				index = self.text.characters.count
			} else {
				index = 0
			}
		}
		
		if let index = index
		{
			self.speak(fromIndex: index)
			
			if paused
			{
				self.pause()
			}
		} else {
			print("Shoo")
		}
		
	}

	
}