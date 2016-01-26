//
//  AppDelegate.swift
//  Dictate Assist
//
//  Created by Kyle Carson on 9/1/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	func applicationDidFinishLaunching(aNotification: NSNotification)
	{
		NSApp.servicesProvider = DictaterService()
		
		if !Dictater.hasBeenUsed
		{
			self.openHowToUseWindow()
		}
		
		let args = NSProcessInfo.processInfo().arguments
		var skip = false
		
		for arg in args[ 1 ..< args.count ]
		{
			if skip
			{
				skip = false
				continue
			}
			
			if arg.hasPrefix("-")
			{
				skip = true
				continue
			}
			
			Speech.sharedSpeech.speak( arg )
			break
		}
	}
	
	func applicationWillTerminate(aNotification: NSNotification) {
		Speech.sharedSpeech.pause()
	}
	
	var howToUseController : NSWindowController?
	
	func openHowToUseWindow()
	{
		if let sb = NSApplication.sharedApplication().windows.first?.windowController?.storyboard,
		let controller = sb.instantiateControllerWithIdentifier("howToUse") as? NSWindowController
		{
			controller.showWindow(self)
			self.howToUseController = controller
			controller.window?.becomeKeyWindow()
			controller.window?.becomeMainWindow()
		}
	}
}

