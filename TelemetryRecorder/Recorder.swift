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
	private(set) public static var sharedLocationManager : CLLocationManager?
	public let locationManager = CLLocationManager()
	//private let motionManager = CMMotionManager()
	private let altimeter : CMAltimeter?
	public var valueUpdated : ((Recorder) -> Void)?
	private(set) public var location : CLLocation?
	private(set) public var heading : CLHeading?
	private(set) public var coordinate : Coordinate?
	private var altDelta = 0.0
	
	override init()
	{
		altimeter = CMAltimeter.isRelativeAltitudeAvailable() ? CMAltimeter() : nil
		
		super.init()
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
		locationManager.pausesLocationUpdatesAutomatically = false
		locationManager.activityType = CLActivityType.Other
		locationManager.distanceFilter = kCLDistanceFilterNone
		
		if CLLocationManager.authorizationStatus() == .NotDetermined {
			locationManager.requestAlwaysAuthorization()
		}
		
		Recorder.sharedLocationManager = locationManager
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
		
		altimeter?.startRelativeAltitudeUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (altData, error) -> Void in
			if let rel = altData?.relativeAltitude {
				self.altDelta += Double(rel)
			}
		})
	}
	
	public func stopRecording()
	{
		locationManager.stopUpdatingHeading()
		locationManager.stopUpdatingLocation()
		
		altimeter?.stopRelativeAltitudeUpdates()
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
	
	/**
	* Gets the vertical delta since the last call and sets it back to 0
	*/
	public var verticalDelta : Double
	{
		get {
			let val = altDelta
			
			altDelta = 0.0
			
			return val
		}
	}
	
	public var recordingAltitudeChanges : Bool
	{
		get {
			return altimeter != nil
		}
	}
}
