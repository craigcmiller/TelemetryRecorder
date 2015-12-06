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
	public var sections : [TableViewSection]
	
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
		
		//let cell = tableView.dequeueReusableCellWithIdentifier(row.reuseIdentifier) ?? row.generateCell(indexPath)
		let cell = row.generateCell(indexPath)
		
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
	
	public func updateHeaderTitleForSection(section : TableViewSection)
	{
		UIView.setAnimationsEnabled(false)
		tableView.beginUpdates()
		
		if let containerView = tableView.headerViewForSection(self.sections.indexOf({ (sec) -> Bool in
			return sec === section
		})!) {
			containerView.textLabel!.text = section.headerTitle
			
			containerView.sizeToFit()
		}
		
		tableView.endUpdates()
		UIView.setAnimationsEnabled(true)
	}
	
	public func updateFooterTitleForSection(section : TableViewSection)
	{
		UIView.setAnimationsEnabled(false)
		tableView.beginUpdates()
		
		if let containerView = tableView.footerViewForSection(self.sections.indexOf({ (sec) -> Bool in
			return sec === section
		})!) {
			containerView.textLabel!.text = section.footerTitle
			
			containerView.sizeToFit()
		}
		
		tableView.endUpdates()
		UIView.setAnimationsEnabled(true)
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
	
	public func addTextFieldRow(title : String, initialText : String, valueChanged : (TableViewRow, NSObject) -> Void) -> TableViewRow
	{
		let row = TableViewRow(cellGenerator: tableViewTextBoxCellGenerator)
		row.title = title
		row.secondary = initialText
		row.valueChanged = valueChanged
		
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
	if row.iconName != nil {
		cell.imageView?.image = UIImage(named: row.iconName!)
	}
	
	return cell
}

public func tableViewTextBoxCellGenerator(row : TableViewRow) -> UITableViewCell
{
	let cell = tableViewDefaultCellGenerator(row)
	
	cell.textLabel?.text = row.title
	cell.selectionStyle = .None
	
	let textField = UITextField()
	textField.frame = CGRectMake(0, 0, 120, 31)
	textField.borderStyle = .RoundedRect
	textField.textAlignment = .Right
	textField.addTarget(row, action: "callValueChanged:", forControlEvents: .AllEditingEvents)
	if let initialText = row.secondary {
		textField.text = initialText
	}
	
	cell.accessoryView = textField
	
	return cell
}

public func tableViewSegmentedControlCellGenerator(row : TableViewRow) -> UITableViewCell
{
	let cell = tableViewDefaultCellGenerator(row)
	
	cell.selectionStyle = .None
	
	let scRow = row as! SegmentedControlTableViewRow
	
	let segmentedControl = UISegmentedControl(items: scRow.labels)
	segmentedControl.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
	segmentedControl.frame = cell.bounds
	segmentedControl.selectedSegmentIndex = scRow.selectedIndex
	
	segmentedControl.addTarget(row, action: "callValueChanged:", forControlEvents: .ValueChanged)
	
	cell.addSubview(segmentedControl)
	
	return cell
}

public class TableViewRow
{
	public var title : String
	public var selectedAction : (TableViewRow, NSIndexPath) -> Void
	public var reuseIdentifier : String?
	public var cellGenerator : (TableViewRow) -> UITableViewCell
	public var valueChanged : ((TableViewRow, NSObject) -> Void)?
	public var secondary : String?
	public var iconName : String?
	
	convenience init()
	{
		self.init(cellGenerator: tableViewDefaultCellGenerator)
	}
	
	init(cellGenerator cg : (TableViewRow) -> UITableViewCell)
	{
		title = ""
		selectedAction = { (action : TableViewRow, indexPath : NSIndexPath) in }
		reuseIdentifier = nil
		cellGenerator = cg
	}
	
	internal func callSelectedAction(indexPath : NSIndexPath)
	{
		selectedAction(self, indexPath)
	}
	
	@objc internal func callValueChanged(sender : NSObject)
	{
		valueChanged?(self, sender)
	}
	
	public func generateCell(indexPath : NSIndexPath) -> UITableViewCell
	{
		return cellGenerator(self)
	}
}

public class SegmentedControlTableViewRow : TableViewRow
{
	public var labels : [String]
	public var selectedIndex : Int
	
	init(labels : [String], initialSelection : Int, cellGenerator cg : (TableViewRow) -> UITableViewCell)
	{
		self.labels = labels
		self.selectedIndex = initialSelection
		
		super.init(cellGenerator: cg)
	}
	
	override func callValueChanged(sender: NSObject)
	{
		let segmentedControl = sender as! UISegmentedControl
		selectedIndex = segmentedControl.selectedSegmentIndex
		
		super.callValueChanged(sender)
	}
}
