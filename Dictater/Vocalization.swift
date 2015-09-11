//
//  Vocalization.swift
//  Dictater
//
//  Created by Kyle Carson on 9/4/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation
import Cocoa

class Vocalization : NSObject, NSSpeechSynthesizerDelegate
{
	let text : String
	
	init(_ text: String)
	{
		self.text = text
	}
	
	lazy private var synthesizer : NSSpeechSynthesizer = {
		let synth = NSSpeechSynthesizer()
		synth.delegate = self
		
		return synth
	}()
	
	var currentRange : NSRange? = NSRange()
	{
		didSet {
			NSNotificationCenter.defaultCenter().postNotificationName(Vocalization.ProgressChangedNotification, object: self)

		}
	}
	
	var didFinish : Bool = false
	
	var isSpeaking : Bool = false
	{
		didSet {
			if oldValue != self.isSpeaking
			{
				NSNotificationCenter.defaultCenter().postNotificationName(Vocalization.IsSpeakingChangedNotification, object: self)
			}
		}
	}
	
	var firstWordRange : NSRange
	{
		let words = self.text.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		let length = words.first?.characters.count ?? 0
		
		return NSRange.init(location: 0, length: length)
	}

	func start()
	{
		self.currentRange = self.firstWordRange
		self.synthesizer.startSpeakingString(self.text)
		
		self.isSpeaking = true
		self.didFinish = false
	}
	
	func pause()
	{
		self.synthesizer.pauseSpeakingAtBoundary(NSSpeechBoundary.ImmediateBoundary)
		
		self.isSpeaking = false
	}

	func continueSpeaking()
	{
		self.self.synthesizer.continueSpeaking()
		
		self.isSpeaking = true
		
	}
	
	static let ProgressChangedNotification = "Vocalization.ProgressChangedNotification"
	static let IsSpeakingChangedNotification = "Vocalization.IsSpeakingChangedNotification"
	
	func speechSynthesizer(sender: NSSpeechSynthesizer, willSpeakWord characterRange: NSRange, ofString string: String)
	{
		self.currentRange = characterRange
	}
	
	func speechSynthesizer(sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
		self.didFinish = true
		self.isSpeaking = false
		self.currentRange = NSRange.init(location: text.characters.count, length: 0)
	}
}