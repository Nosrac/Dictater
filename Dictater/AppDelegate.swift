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
	}
	
	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}
}

