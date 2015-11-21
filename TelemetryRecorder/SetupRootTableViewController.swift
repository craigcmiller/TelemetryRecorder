//
//  SetupRootTableViewController.swift
//  TelemetryRecorder
//
//  Created by Craig Miller on 14/11/2015.
//  Copyright © 2015 CMSoftware. All rights reserved.
//

import UIKit

class SetupRootTableViewController : TableViewHelperController {
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Setup Logging";
		
		let runSection = addSection()
		
		runSection.addRow("Begin recording") { (row, indexPath) -> Void in
			let recodingStoryboard = UIStoryboard(name: "Recording", bundle: nil)
			
			let recordingViewController = recodingStoryboard.instantiateInitialViewController() as! RecordingViewController
			recordingViewController.callingViewController = self
			
			recordingViewController.modalTransitionStyle = .FlipHorizontal
			let colorSpace = CGColorSpaceCreateDeviceRGB()
			recordingViewController.view.layer.borderColor = CGColorCreate(colorSpace, [0.9, 0.1, 0.1, 1])
			recordingViewController.view.layer.borderWidth = 3
			recordingViewController.view.layer.cornerRadius = 10
			
			self.presentViewController(recordingViewController, animated: true, completion: { () -> Void in
			})
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
