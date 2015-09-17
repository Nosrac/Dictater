//
//  NSProgressIndicator+Animate.swift
//  Dictater
//
//  Adapted by Kyle Carson on 9/3/15.
//  Created by Matthias Gansrigler on 06.05.2015.
//  Copyright (c) 2015 Eternal Storms Software. All rights reserved.
//

import Foundation
import Cocoa

class ESSProgressBarAnimation : NSAnimation
{
	let indicator : NSProgressIndicator
	let initialValue : Double
	let newValue : Double
	
	init(_ progressIndicator: NSProgressIndicator, newValue: Double)
	{
		self.indicator = progressIndicator
		self.initialValue = progressIndicator.doubleValue
		self.newValue = newValue
		
		super.init(duration: 0.2, animationCurve: .EaseIn)
		self.animationBlockingMode = .NonblockingThreaded
	}

	required init?(coder aDecoder: NSCoder) {
		
		indicator = NSProgressIndicator()
		initialValue = 0
		newValue = 0
		
		super.init(coder: aDecoder)
	}
	
	override var currentProgress : NSAnimationProgress
	{
		didSet {
			let delta = self.newValue - self.initialValue
			
			self.indicator.doubleValue = self.initialValue + (delta * Double(currentProgress))
		}
	}
}

extension NSProgressIndicator
{
	func animateToDoubleValue(value: Double) -> NSAnimation
	{
		let animation = ESSProgressBarAnimation(self, newValue: value)
		animation.startAnimation()
		return animation
	}
}