//
//  RecordingInfoViewController.swift
//  TelemetryRecorder
//
//  Created by Craig Miller on 21/11/2015.
//  Copyright © 2015 CMSoftware. All rights reserved.
//

import Foundation

class RecordingInfoViewController : TableViewHelperController
{
	public var path : String?
	
	override func viewDidLoad()
	{
		title = path!
		
		let optionsSection = addSection()
		
		optionsSection.addRow("Show on map", selectedAction: { (row, indexPath) -> Void in
			
		})
		
		optionsSection.addRow("Share", selectedAction: { (row, indexPath) -> Void in
			
		})
		
		let positionsSection = addSection()
		
	}
	
	override func viewDidAppear(animated: Bool)
	{
		
	}
}
