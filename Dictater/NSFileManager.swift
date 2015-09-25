//
//  NSFileManager.swift
//  Converter Box
//
//  Created by Kyle Carson on 9/15/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation

extension NSFileManager
{
	func directoryExistsAtPath (path : String) -> Bool
	{
		var isDirectory : ObjCBool = false
		if self.fileExistsAtPath(path, isDirectory: &isDirectory)
		{
			return Bool(isDirectory)
		} else {
			return false
		}
	}
	
	func getTemporaryFile(fileExtension : String = "rand") -> String
	{
		let tempDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first!
		
		var filename : String?
		
		while filename == nil
		{
			filename = "\(tempDir)/\(rand()).\(fileExtension)"
			
			if NSFileManager.defaultManager().fileExistsAtPath(filename!)
			{
				filename = nil
			} else {
				do
				{
					try "".writeToFile(filename!, atomically: true, encoding: NSUTF8StringEncoding)
				} catch {
					filename = nil
				}
			}
		}
		
		return filename!
	}
	
	func getMimeType(file file: String) -> String?
	{
		if !NSFileManager.defaultManager().fileExistsAtPath(file)
		{
			return nil
		}
		
		if file.hasSuffix(".epub")
		{
			return "application/epub+zip"
		}
		
		let nsstringFile : NSString = file as NSString
		
		if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, nsstringFile.pathExtension as CFStringRef, nil)?.takeRetainedValue()
		{
			if let mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)
			{
				return mimeType.takeRetainedValue() as String
			}
		}
		
		return "application/octet-stream";
	}
}