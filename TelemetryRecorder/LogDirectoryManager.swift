//
//  LogDirectoryManager.swift
//  TelemetryRecorder
//
//  Created by Craig Miller on 21/11/2015.
//  Copyright © 2015 CMSoftware. All rights reserved.
//

import Foundation

public class LogDirectoryManager
{
	public static let shared = LogDirectoryManager()
	private let url : NSURL
	
	private init()
	{
		let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
		
		url = NSURL(fileURLWithPath: documentsPath).URLByAppendingPathComponent("logs")
		
		debugPrint("Log directory: \(url.path!)")
		
		// Create the logs directory if it does not exist
		var isDirectory : ObjCBool = false
		if !NSFileManager.defaultManager().fileExistsAtPath(url.path!, isDirectory: &isDirectory) {
			do {
				try NSFileManager.defaultManager().createDirectoryAtPath(url.path!, withIntermediateDirectories: false, attributes: nil)
			} catch let error as NSError {
				print(error.localizedDescription)
			}
		}
	}
	
	public func newLogFilename() -> String
	{
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH.mm.ss"
		
		return "\(dateFormatter.stringFromDate(NSDate())).csv"
	}
	
	public func newLogURL() -> NSURL
	{
		return url.URLByAppendingPathComponent(newLogFilename())
	}
	
	public func newLogPath() -> String
	{
		return newLogURL().path!
	}
	
	public func allLogPaths() -> [String]
	{
		do {
			return try NSFileManager.defaultManager().contentsOfDirectoryAtPath(url.path!)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		
		return []
	}
}
