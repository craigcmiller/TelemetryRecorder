//
//  TableViewHelper.swift
//  TelemetryRecorder
//
//  Created by Craig Miller on 15/11/2015.
//  Copyright © 2015 CMSoftware. All rights reserved.
//

import Foundation
import UIKit

public class TableViewHelperController : UITableViewController
{
	private var sections : [TableViewSection]
	
	public override init(style : UITableViewStyle)
	{
		sections = []
		
		super.init(style: style)
	}
	
	public required init?(coder aDecoder: NSCoder)
	{
		sections = []
		
		super.init(coder: aDecoder)
	}
	
	public func addSection(section : TableViewSection)
	{
		sections.append(section)
	}
	
	public func addSection() -> TableViewSection
	{
		let newSection = TableViewSection()
		
		addSection(newSection)
		
		return newSection
	}
	
	public func clearSections()
	{
		sections.removeAll()
	}
	
	private func rowAtIndexPath(indexPath : NSIndexPath) -> TableViewRow
	{
		return sections[indexPath.section][indexPath.row]
	}
	
	public override func tableView(tableView : UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let row = rowAtIndexPath(indexPath)
		
		let cell = tableView.dequeueReusableCellWithIdentifier(row.reuseIdentifier) ?? row.generateCell(indexPath)
		
		
		return cell;
	}
	
	public override func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
		return sections.count
	}
	
	public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return sections[section].rowCount
	}
	
	public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
	{
		return sections[section].headerTitle
	}
	
	public override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String?
	{
		return sections[section].footerTitle
	}
	
	public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		let row = rowAtIndexPath(indexPath)
		
		row.callSelectedAction(indexPath)
	}
}

public class TableViewSection
{
	private var rows : [TableViewRow]
	public var headerTitle : String?
	public var footerTitle : String?
	
	public required init()
	{
		rows = []
	}
	
	public func clearRows()
	{
		rows.removeAll()
	}
	
	public func addRow(row : TableViewRow)
	{
		rows.append(row)
	}
	
	public func addRow(title : String, selectedAction : (TableViewRow, NSIndexPath) -> Void) -> TableViewRow
	{
		let row = TableViewRow()
		row.title = title
		row.selectedAction = selectedAction
		
		addRow(row)
		
		return row
	}
	
	public var rowCount : Int
	{
		get { return rows.count }
	}
	
	public subscript(rowIndex : Int) -> TableViewRow
	{
		get { return rows[rowIndex] }
	}
}

public func tableViewDefaultCellGenerator(row : TableViewRow) -> UITableViewCell
{
	let cell = UITableViewCell(style: .Default, reuseIdentifier: row.reuseIdentifier)
	
	cell.textLabel?.text = row.title
	
	return cell
}

public class TableViewRow
{
	public var title : String
	public var selectedAction : (TableViewRow, NSIndexPath) -> Void
	public var reuseIdentifier : String
	public var cellGenerator : (TableViewRow) -> UITableViewCell
	
	init()
	{
		title = ""
		selectedAction = { (action : TableViewRow, indexPath : NSIndexPath) in }
		reuseIdentifier = "default";
		cellGenerator = tableViewDefaultCellGenerator
	}
	
	public func	callSelectedAction(indexPath : NSIndexPath)
	{
		selectedAction(self, indexPath)
	}
	
	public func generateCell(indexPath : NSIndexPath) -> UITableViewCell
	{
		return cellGenerator(self)
	}
}
