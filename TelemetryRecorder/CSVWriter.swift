//
//  CSVWriter.swift
//  TelemetryRecorder
//
//  Created by Craig Miller on 16/11/2015.
//  Copyright © 2015 CMSoftware. All rights reserved.
//

import Foundation

public class CSVWriter
{
	private let out : NSOutputStream
	private let separator : [UInt8]
	private let newLine : [UInt8]
	
	public init(path : String)
	{
		separator = [UInt8](",".utf8)
		newLine = [UInt8]("\n".utf8)
		
		out = NSOutputStream(toFileAtPath: path, append: true)!
		out.open()
	}
	
	deinit
	{
		out.close()
	}
	
	public func writeLine(items : [String])
	{
		for var i = 0; i < items.count; i++ {
			if i > 0 {
				out.write(separator, maxLength: separator.count)
			}
			
			let item = items[i]
			
			let bytes = [UInt8](item.utf8)
			out.write(bytes, maxLength: bytes.count)
		}
		
		let writtenBytes = out.write(newLine, maxLength: newLine.count)
		
		debugPrint("Written: \(writtenBytes)")
		
		debugPrint(items, separator: ", ")
	}
	
	public func writeLine(items : String...)
	{
		for var i = 0; i < items.count; i++ {
			if i > 0 {
				out.write(separator, maxLength: separator.count)
			}
			
			let item = items[i]
			
			let bytes = [UInt8](item.utf8)
			out.write(bytes, maxLength: bytes.count)
		}
		
		out.write(newLine, maxLength: newLine.count)
	}
}
