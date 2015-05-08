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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            self.locationManager.requestAlwaysAuthorization()
        }
        

        self.map.delegate = self
        
        initBeacon()
        transmitBeacon(true)
        // Do any additional setup after loading the view.
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            self.locationManager.startUpdatingLocation()
        }
    }


    func initBeacon () {
        beaconRegion = CLBeaconRegion(proximityUUID: UUID, major: 1, minor: 1, identifier: "beacon");
    }
    
    func transmitBeacon(bool:Bool) {
        beaconPeripheralData = beaconRegion.peripheralDataWithMeasuredPower(-59)
        peripheralManager = CBPeripheralManager(delegate: self, queue: dispatch_get_main_queue())
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
