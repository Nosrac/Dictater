//
//  NSTextView.swift
//  Dictater
//
//  Created by Kyle Carson on 9/14/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation
import Cocoa

extension NSTextView
{
	// Tweaked from http://lists.apple.com/archives/cocoa-dev/2005/Jun/msg01909.html
	var visibleRange : NSRange
	{
		guard let scrollView = self.enclosingScrollView else {
			return NSRange()
		}
		guard let layoutManager = self.layoutManager else {
			return NSRange()
		}
		guard let textContainer = self.textContainer else {
			return NSRange()
		}
		
		var rect = scrollView.documentVisibleRect
		rect.origin.x -= self.textContainerOrigin.x
		rect.origin.y -= self.textContainerOrigin.y
		
		let glyphRange = layoutManager.glyphRangeForBoundingRect(rect, inTextContainer: textContainer)
		let charRange = layoutManager.characterRangeForGlyphRange(glyphRange, actualGlyphRange: nil)
		
		return charRange
	}
	
	func scrollRangeToVisible(range: NSRange, smart: Bool = false)
	{
		if !smart
		{
			super.scrollRangeToVisible(range)
			return
		}
		
		let visibleRange = self.visibleRange
		
		if visibleRange.location <= range.location && range.location < (visibleRange.location + visibleRange.length)
		{
			// Do Nothing
		} else {
			Swift.print("Update")
			self.enclosingScrollView?.hasHorizontalScroller = false
			self.scrollRangeToVisible(range)
			self.enclosingScrollView?.hasHorizontalScroller = true
		}
	}
}