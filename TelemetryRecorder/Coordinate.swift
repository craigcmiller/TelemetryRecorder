//
//  Coordinate.swift
//  TelemetryRecorder
//
//  Created by Craig Miller on 15/11/2015.
//  Copyright © 2015 CMSoftware. All rights reserved.
//

import Foundation

public struct Coordinate : CustomStringConvertible
{
	public let latitude : Double
	public let longitude : Double
	public let altitude : Distance
	
	public init(latitude : Double, longitude : Double)
	{
		self.init(latitude: latitude, longitude: longitude, altitude: Distance(value: 0, units: .metres))
	}
	
	public init(latitude : Double, longitude : Double, altitude : Distance)
	{
		self.latitude = latitude
		self.longitude = longitude
		self.altitude = altitude
	}
	
	public var description : String
	{
		get { return "\(latitude), \(longitude)" }
	}
}
