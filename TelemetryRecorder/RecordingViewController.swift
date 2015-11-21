//
//  RecordingViewController.swift
//  TelemetryRecorder
//
//  Created by Craig Miller on 15/11/2015.
//  Copyright © 2015 CMSoftware. All rights reserved.
//

import Foundation
import UIKit

class RecordingViewController : UIViewController
{
	weak var callingViewController : UIViewController?
	private let recorder = Recorder()
	@IBOutlet weak var dataTextView: UITextView!
	private let writer : CSVWriter
	private var lastUpdated = CFAbsoluteTimeGetCurrent()
	
	required init?(coder aDecoder: NSCoder)
	{
		let writePath = LogDirectoryManager.shared.newLogPath()
		print(writePath)
		writer = CSVWriter(path: writePath)
		
		super.init(coder: aDecoder)
	}
	
	deinit
	{
		debugPrint("RVC deinit")
	}
	
	func recorderValueUpdated(r : Recorder)
	{
		if CFAbsoluteTimeGetCurrent() - lastUpdated < 1 {
			return;
		}
		
		lastUpdated = CFAbsoluteTimeGetCurrent()
		
		var dataStr = String()
		
		var values = [String]()
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		values.append(dateFormatter.stringFromDate(NSDate()))
		
		if let coord = r.coordinate {
			values.append(coord.latitude.description)
			values.append(coord.longitude.description)
			values.append(r.location!.horizontalAccuracy.description)
			values.append(coord.altitude.metres.description)
			values.append(r.location!.verticalAccuracy.description)
			
			dataStr.appendContentsOf(coord.description)
		} else {
			values.append("")
			values.append("")
			values.append("")
			values.append("")
			values.append("")
		}
		
		if let heading = r.heading {
			values.append(heading.magneticHeading.description)
		} else {
			values.append("")
		}
		
		writer.writeLine(values)
		
		dataTextView.text = dataStr
	}
	
	override func viewDidLoad()
	{
		dataTextView.text = ""
		
		recorder.valueUpdated = recorderValueUpdated;
		
		recorder.startRecording()
	}
	
	@IBAction func stopRecording(sender: UIButton)
	{
		recorder.valueUpdated = nil
		
		callingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
		})
	}
}
