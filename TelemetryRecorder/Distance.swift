//
//  Distance.swift
//  TelemetryRecorder
//
//  Created by Craig Miller on 15/11/2015.
//  Copyright © 2015 CMSoftware. All rights reserved.
//

import Foundation

public struct Distance
{
	public let metres : Double
	private let nauticalMilesInMetres = 1852.0
	private let statuteMilesInMetres = 1609.344
	private let feetInMetres = 0.3048
	
	public init(value : Double, units : DistanceUnits)
	{
		switch (units) {
		case .metres:
			metres = value
		case .feet:
			metres = value * feetInMetres
		case .kilometres:
			metres = value * 1000
		case .nauticalMiles:
			metres = value * nauticalMilesInMetres
		case .statuteMiles:
			metres = value * statuteMilesInMetres
		}
	}
	
	public func value(units : DistanceUnits) -> Double
	{
		switch (units) {
		case .metres:
			return metres;
		case .feet:
			return metres / feetInMetres
		case .kilometres:
			return metres / 1000
		case .nauticalMiles:
			return metres / nauticalMilesInMetres
		case .statuteMiles:
			return metres / statuteMilesInMetres
		}
	}
}

public enum DistanceUnits : Int
{
	case metres = 1
	case feet = 2
	case kilometres = 3
	case nauticalMiles = 4
	case statuteMiles = 5
}
