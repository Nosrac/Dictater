//
//  FileManager.swift
//  Converter Box
//
//  Created by Kyle Carson on 9/15/15.
//  Copyright © 2015 Kyle Carson. All rights reserved.
//

import Foundation

extension FileManager
{
	func directoryExistsAtPath (path : String) -> Bool
	{
		var isDirectory : ObjCBool = false
		if self.fileExists(atPath: path, isDirectory: &isDirectory)
		{
			return isDirectory.boolValue
		} else {
			return false
		}
	}
	
	func getTemporaryFile(fileExtension : String = "rand") -> String?
	{
		var tempDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
		
		if let identifier = Bundle.main.bundleIdentifier
		{
			tempDir = "\(tempDir)/\(identifier)/"
		}
		
		do
		{
			try FileManager.default.createDirectory(atPath: tempDir, withIntermediateDirectories: true, attributes: nil)
			
			var filename : String?
			
			while filename == nil
			{
				filename = "\(tempDir)/\(arc4random()).\(fileExtension)"
				
				if FileManager.default.fileExists(atPath: filename!)
				{
					filename = nil
				} else {
					do
					{
						try "".write(toFile: filename!, atomically: true, encoding: String.Encoding.utf8)
					} catch {
						filename = nil
					}
				}
			}
			
			return filename
		} catch {
			return nil
		}
	}
	
	func getMimeType(file file: String) -> String?
	{
		if !FileManager.default.fileExists(atPath: file)
		{
			return nil
		}
		
		if file.hasSuffix(".epub")
		{
			return "application/epub+zip"
		}
		
		let nsstringFile : NSString = file as NSString
		
		if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, nsstringFile.pathExtension as CFString, nil)?.takeRetainedValue()
		{
			if let mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)
			{
				return mimeType.takeRetainedValue() as String
			}
		}
		
		return "application/octet-stream";
	}
}
