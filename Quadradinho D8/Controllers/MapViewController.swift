//
//  MapViewController.swift
//  Quadradinho D8
//
//  Created by Adriano Soares on 07/05/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, CBPeripheralManagerDelegate  {
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    var beaconPeripheralData: NSMutableDictionary!
    var peripheralManager: CBPeripheralManager!
    
    var beaconMajor = ""
    
    var UUID = NSUUID(UUIDString: "D56FEA44-29D9-4196-8B3C-6CB7E6136F1C")
    var beaconRegion:CLBeaconRegion?
    
    var beaconsFound: [CLBeacon] = [CLBeacon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            self.locationManager.requestAlwaysAuthorization()
        }
        

        var teste = "string"
        
        self.map.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeState:"), name: "transmitNotification", object: nil)
        
        transmitBeacon(false)

    }

    
    override func viewWillAppear(animated: Bool) {
        var location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        if let userLocation = locationManager.location {
            location = CLLocationCoordinate2D(
                latitude: userLocation.coordinate.latitude,
                longitude: userLocation.coordinate.longitude
            )
        }
        
        var span = MKCoordinateSpanMake(0.01, 0.01)
        var region = MKCoordinateRegion(center: location, span: span)
        
        self.map.setRegion(region, animated: true)
        self.map.showsUserLocation = true;
        
    }
    
    // MARK: - Beacon General
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            self.locationManager.startUpdatingLocation()
            //locationManager.startMonitoringForRegion(beaconRegion)
        }
    }
    
    func initBeacon () {
        if let installation = (UIApplication.sharedApplication().delegate as! AppDelegate).installation {
            if let hash: NSNumber = (installation.objectForKey("hash")) as? NSNumber {
                var major: UInt16 = hash.unsignedShortValue
                beaconRegion = CLBeaconRegion (proximityUUID: UUID, major: major, identifier: "beacon");
                //println(major.description)
            }
        }
    }
    
    // MARK: - Beacon Transmitter
    
    func changeState(notification: NSNotification) {
        var val: Bool = notification.object as! Bool
        transmitBeacon(val)
    }
    
    func transmitBeacon(transmit:Bool) {
        if (transmit) {
            locationManager.stopMonitoringForRegion(beaconRegion)
            initBeacon()
            beaconPeripheralData = beaconRegion!.peripheralDataWithMeasuredPower(-59)
            peripheralManager = CBPeripheralManager(delegate: self, queue: dispatch_get_main_queue())
        } else {
            if let peripheralManager = peripheralManager {
                peripheralManager.stopAdvertising()
            }
            if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
                beaconRegion = CLBeaconRegion(proximityUUID: UUID, identifier: "beacon");
                locationManager.startMonitoringForRegion(beaconRegion)
            }
        }

    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if (peripheral.state == .PoweredOn) {
            peripheralManager.startAdvertising(beaconPeripheralData as [NSObject : AnyObject]!)
        } else if (peripheral.state == .PoweredOff) {
            peripheralManager.stopAdvertising()
        }
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager!, error: NSError!) {
        println(error)
    }
    
    // MARK: - Beacon Receiver
    
    func monitoreRegion() {
        if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            locationManager.startMonitoringForRegion(beaconRegion)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        var circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.redColor()
        circleRenderer.fillColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        return circleRenderer
    }
    
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        if (beacons.count > 0) {
            
            for beacon in beacons {
                var code = beacon.major
                var query = PFQuery(className: "RestrictedZone")
                query.whereKey("code", equalTo: code)
                query.findObjectsInBackgroundWithBlock {
                    (objects, error) in
                    for zone in objects! {
                        var latitude = zone.objectForKey("latitude") as! CLLocationDegrees
                        var longitude = zone.objectForKey("longitude") as! CLLocationDegrees
                        var location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        var radius = zone.objectForKey("size") as! CLLocationDistance
                        var circle = MKCircle(centerCoordinate: location, radius: radius)
                        self.map.addOverlay(circle)
                    
                    }
                    
                }

                var notification = UILocalNotification()
                notification.alertTitle = "Be careful"
                notification.alertBody = "Entering Restricted Region"
                notification.fireDate = NSDate(timeIntervalSinceNow: 10)
                UIApplication.sharedApplication().scheduleLocalNotification(notification)

            }
            beaconsFound = beacons as! [CLBeacon]
        }
        locationManager.stopRangingBeaconsInRegion(region)
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        if let userLocation = locationManager.location {
            location = CLLocationCoordinate2D(
                latitude: userLocation.coordinate.latitude,
                longitude: userLocation.coordinate.longitude
            )
        }
        
        var span = MKCoordinateSpanMake(0.01, 0.01)
        var region = MKCoordinateRegion(center: location, span: span)
        
        self.map.setRegion(region, animated: true)
        self.map.showsUserLocation = true;
    }
    
    override func viewWillDisappear(animated: Bool) {
        locationManager.stopMonitoringForRegion(beaconRegion)
    }

}
