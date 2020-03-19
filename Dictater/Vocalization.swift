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
	
	lazy var synthesizer : NSSpeechSynthesizer = {
		let synth = NSSpeechSynthesizer()
		synth.delegate = self
		
		return synth
	}()
	
	var currentRange : NSRange? = NSRange()
	{
		didSet {
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: Vocalization.ProgressChangedNotification), object: self)

		}
	}
	
	var didFinish : Bool = false
	
	var isSpeaking : Bool = false
	{
		didSet {
			if oldValue != self.isSpeaking
			{
				NotificationCenter.default.post(name: NSNotification.Name(rawValue: Vocalization.IsSpeakingChangedNotification), object: self)
			}
		}
	}
	
	var firstWordRange : NSRange
	{
		let words = self.text.components(separatedBy: CharacterSet.whitespacesAndNewlines)
		let length = words.first?.count ?? 0
		
		return NSRange.init(location: 0, length: length)
	}

	func start()
	{
		if self.text.count > 0
		{
			self.currentRange = self.firstWordRange
			self.synthesizer.startSpeaking(self.text)
			
			self.isSpeaking = true
			self.didFinish = false
		} else {
			self.isSpeaking = false
			self.didFinish = true
			
			self.currentRange = NSRange.init(location: 0, length: self.text.count)
		}
	}
	
	func pause()
	{
		self.synthesizer.pauseSpeaking(at: NSSpeechSynthesizer.Boundary.immediateBoundary)
		
		self.isSpeaking = false
	}

	func continueSpeaking()
	{
		self.self.synthesizer.continueSpeaking()
		
		self.isSpeaking = true
		
	}
	
	static let ProgressChangedNotification = "Vocalization.ProgressChangedNotification"
	static let IsSpeakingChangedNotification = "Vocalization.IsSpeakingChangedNotification"
	
	func speechSynthesizer(_ sender: NSSpeechSynthesizer, willSpeakWord characterRange: NSRange, of string: String)
	{
		self.currentRange = characterRange
	}
	
	func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
		self.didFinish = true
		self.isSpeaking = false
		self.currentRange = NSRange.init(location: text.count, length: 0)
	}
}
