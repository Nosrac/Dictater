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
			if let vocalization = self.speech.vocalization, vocalization.isSpeaking
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
	var totalDuration : TimeInterval?
	{
		didSet {
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: Speech.TotalDurationChangedNotification), object: self)
		}
	}
	
	var estimatedProgressSeconds : TimeInterval?
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
			vocalization.synthesizer.getSpeechDuration(string: self.text)
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
		
		var enumerationOption : NSString.EnumerationOptions
		{
			if self == .Sentence
			{
				return .bySentences
			} else {
				return .byParagraphs
			}
		}
	}
	
	static let ProgressChangedNotification = "Speech.ProgressChangedNotification"
	static let TotalDurationChangedNotification = "Speech.TotalDurationChangedNotification"
	
	var progress : Progress
	{
		let progress = Progress()
		if let range = self.range
		{
			progress.totalUnitCount = Int64(text.count)
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
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: Speech.ProgressChangedNotification), object: self)
	}
	
	private func speak(fromIndex index: Int)
	{
		if let vocalization = self.vocalization
		{
			NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Vocalization.ProgressChangedNotification), object: vocalization)
			
			vocalization.pause()
			self.vocalization = nil
		}
		
		var effectiveIndex = index
		
		if (effectiveIndex < 0)
		{
			effectiveIndex = 0
		}
		
		let vocalization : Vocalization
		let nsstring = NSString(string: self.text).substring(from: effectiveIndex)
		
		vocalization = Vocalization( String(nsstring) )
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.progressDidChange), name: NSNotification.Name(rawValue: Vocalization.ProgressChangedNotification), object: vocalization)
		
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
			range = NSRange(location: currentLocation, length: self.text.count - currentLocation)
		} else {
			// TODO: Maybe a bug here?
			options = options.union(.reverse)
			
			range = NSRange(location: 0, length: currentLocation)
		}
			
		NSString(string: self.text).enumerateSubstrings(in: range, options: options, using: { (substring, substringRange, enclosingRange, stop) -> Void in
			guard let substring = substring, substring.count > 0 else {
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
				index = self.text.count
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
