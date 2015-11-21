//
//  Recorder.swift
//  TelemetryRecorder
//
//  Created by Craig Miller on 14/11/2015.
//  Copyright © 2015 CMSoftware. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

public class Recorder : NSObject, CLLocationManagerDelegate
{
	private let locationManager = CLLocationManager()
	private let motionManager = CMMotionManager()
	private let altimeter : CMAltimeter?
	public var valueUpdated : ((Recorder) -> Void)?
	private(set) public var location : CLLocation?
	private(set) public var heading : CLHeading?
	private(set) public var coordinate : Coordinate?
	
	override init()
	{
		altimeter = CMAltimeter.isRelativeAltitudeAvailable() ? CMAltimeter() : nil
		
		super.init()
		
		locationManager.delegate = self
		
		if CLLocationManager.authorizationStatus() == .NotDetermined {
			locationManager.requestAlwaysAuthorization()
		}
	}
	
	deinit
	{
		debugPrint("deinit recorder")
		
		valueUpdated = nil
		
		stopRecording()
	}
	
	public func startRecording()
	{
		locationManager.startUpdatingLocation()
		locationManager.startUpdatingHeading()
	}
	
	public func stopRecording()
	{
		locationManager.stopUpdatingHeading()
		locationManager.stopUpdatingLocation()
	}
	
	public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
	{
		location = locations.last
		
		coordinate = Coordinate(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude, altitude: Distance(value: location!.altitude, units: .metres))
		
		valueUpdated?(self)
	}
	
	public func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
	{
		heading = newHeading
		
		valueUpdated?(self)
	}
}
