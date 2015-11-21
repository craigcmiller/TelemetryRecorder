//
//  PreviousRecordingsViewController.swift
//  TelemetryRecorder
//
//  Created by Craig Miller on 21/11/2015.
//  Copyright © 2015 CMSoftware. All rights reserved.
//

import Foundation

class PreviousRecordingsViewController : TableViewHelperController
{
	private var paths : [String]?
	private let previousRecordingsSection = TableViewSection()
	
	override func viewDidLoad()
	{
		title = "Previous Telemetry Logs"
		
		addSection(previousRecordingsSection)
	}
	
	override func viewDidAppear(animated: Bool)
	{
		populate()
	}
	
	private func populate()
	{
		previousRecordingsSection.clearRows()
		
		paths = LogDirectoryManager.shared.allLogPaths().sort()
		
		for path in paths! {
			let url = NSURL(fileURLWithPath: path)
			let filename = url.lastPathComponent!.stringByReplacingOccurrencesOfString(".csv", withString: "")
			
			previousRecordingsSection.addRow(filename, selectedAction: { (row, indexPath) -> Void in
				let recordingInfoViewController = self.storyboard!.instantiateViewControllerWithIdentifier("RecordingInfoViewController") as! RecordingInfoViewController
				
				recordingInfoViewController.path = self.paths![indexPath.row]
				
				self.navigationController?.pushViewController(recordingInfoViewController, animated: true)
			})
		}
		
		tableView.reloadData()
	}
}
