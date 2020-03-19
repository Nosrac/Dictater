//
//  SpeechTimer.swift
//  Dictater
//
//  Created by Kyle Carson on 9/24/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation
import Cocoa

extension NSSpeechSynthesizer
{
	func getSpeechDuration(string: String, callback: @escaping ((_ duration: TimeInterval) -> ()))
	{
		let timer = NSSpeechSynthesizerTimer(text: string, synthesizer: self)
		timer.finished = {
			if let duration = timer.duration
			{
				callback(duration)
			}
		}
		timer.start()
	}
}

class NSSpeechSynthesizerTimer : NSObject, NSSpeechSynthesizerDelegate
{
	let synthesizer : NSSpeechSynthesizer
	let text : String
	
	var duration : TimeInterval?
	
	var finished : (() -> ())?
	
	private var tempFile : String?
	
	init(text: String, synthesizer: NSSpeechSynthesizer? = nil)
	{
		self.text = text
		self.synthesizer = synthesizer ?? NSSpeechSynthesizer()
	}
	
	func start() -> Bool
	{
		if let tempFile = FileManager.default.getTemporaryFile( fileExtension: "AIFF"),
		let synthesizer = NSSpeechSynthesizer(voice: self.synthesizer.voice())
		{
			synthesizer.rate = self.synthesizer.rate
			synthesizer.delegate = self
			synthesizer.startSpeaking(self.text, to: URL(fileURLWithPath: tempFile))
			
			self.tempFile = tempFile
			return true
		}
		return false
	}
	
	func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool)
	{
		guard let tempFile = self.tempFile else {
			return
		}
		
		if let sound = NSSound(contentsOfFile: tempFile, byReference: false)
		{
			self.duration = sound.duration
			self.finished?()
		}
		try! FileManager.default.removeItem(atPath: tempFile)
	}
}
