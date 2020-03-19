//
//  NSView+backgroundColor.swift
//  Dictate Assist
//
//  Parts from http://stackoverflow.com/a/31461380
//

import Foundation
import Cocoa

@IBDesignable
extension NSView
{
	@IBInspectable var backgroundColor: NSColor? {
		get {
			if let colorRef = self.layer?.backgroundColor {
				return NSColor(cgColor: colorRef)
			} else {
				return nil
			}
		}
		set {
			self.wantsLayer = true
			self.layer?.backgroundColor = newValue?.cgColor
		}
	}
}
