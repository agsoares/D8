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

    var UUID = NSUUID(UUIDString: "D56FEA44-29D9-4196-8B3C-6CB7E6136F1C")
    var beaconRegion:CLBeaconRegion!
    
    var beaconsFound: [CLBeacon] = [CLBeacon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            self.locationManager.requestAlwaysAuthorization()
        }

        self.map.delegate = self
        
        initBeacon()
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
        
        var span = MKCoordinateSpanMake(0.05, 0.05)
        var region = MKCoordinateRegion(center: location, span: span)
        
        self.map.setRegion(region, animated: true)
        self.map.showsUserLocation = true;
        
    }
    
    // MARK: - Beacon General
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            self.locationManager.startUpdatingLocation()
            locationManager.startMonitoringForRegion(beaconRegion)
        }
    }
    
    func initBeacon () {
        beaconRegion = CLBeaconRegion(proximityUUID: UUID, major: 1, minor: 1, identifier: "beacon");
    }
    
    // MARK: - Beacon Transmitter
    
    func transmitBeacon(transmit:Bool) {
        if (transmit) {
            locationManager.stopMonitoringForRegion(beaconRegion)
            beaconPeripheralData = beaconRegion.peripheralDataWithMeasuredPower(-59)
            peripheralManager = CBPeripheralManager(delegate: self, queue: dispatch_get_main_queue())
        } else {
            if let peripheralManager = peripheralManager {
                peripheralManager.stopAdvertising()
            }
            if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
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
        println("enter regionnnn")
        locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("exit regionnnn")
        locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        println("start looking regionnnn")
        locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        println("ranging beacons")
        
        if (beacons.count > 0) {
            beaconsFound = beacons as! [CLBeacon]
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        locationManager.stopMonitoringForRegion(beaconRegion)
    }

}
