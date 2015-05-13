//
//  SettingsTableViewController.swift
//  Quadradinho D8
//
//  Created by Daniel Amarante on 5/8/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit
import StoreKit

class SettingsTableViewController: UITableViewController, SKStoreProductViewControllerDelegate {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showStoreView(sender: AnyObject) {
        
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [SKStoreProductParameterITunesItemIdentifier :
            NSNumber(integer: 676059878)]
        
        storeViewController.loadProductWithParameters(parameters,
            completionBlock: {result, error in
                if result {
                   
                    self.presentViewController(storeViewController,
                        animated: true, completion: nil)
                }
                
        })
    }
    
    
    func productViewControllerDidFinish(viewController:
        SKStoreProductViewController!) {
            viewController.dismissViewControllerAnimated(true,
                completion: nil)
    }
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        
        var products = response.products
        
        if (products.count != 0) {
            // Display the a “buy product” screen containing details
            // from product object
        }
        
        products = response.invalidProductIdentifiers
        
        for product in products
        {
            // Handle invalid product IDs if required
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        
        for transaction in transactions as! [SKPaymentTransaction] {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.Purchased:
                if (transaction.downloads != nil) {
                    SKPaymentQueue.defaultQueue().startDownloads(
                        transaction.downloads)
                } else {
                    // Unlock feature or content here before
                    // finishing transaction
                    SKPaymentQueue.defaultQueue().finishTransaction(
                        transaction)
                }
                
            case SKPaymentTransactionState.Failed:
                SKPaymentQueue.defaultQueue().finishTransaction(
                    transaction)
                
            default:
                break
            }
        }
    }

    @IBAction func premiumSelecter(sender: UISwitch) {
        NSNotificationCenter.defaultCenter().postNotificationName ("transmitNotification", object:sender.on )
        
    }
    
    @IBAction func removeZonesButtonPressed() {
        var query = PFQuery(className: "RestrictedZone")
        
        if let installation = (UIApplication.sharedApplication().delegate as! AppDelegate).installation {
            if let hash: NSNumber = (installation.objectForKey("hash")) as? NSNumber {
                query.whereKey("code", equalTo: hash)
            }
        }
        query.findObjectsInBackgroundWithBlock {
            (objects, error) in
            for zone in objects! {
                zone.deleteInBackground()
                
            }
            
        }

    }
    @IBAction func createZoneButtonPressed() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Danger Zone", message: "Choose your danger zone range!", preferredStyle: .Alert)
        
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Done", style: .Default) { action -> Void in
            var size = actionSheetController.textFields![0] as! UITextField
            if let size = size.text.toInt() {
                self.createRestrictedZone(size)
            }
            
        }
        actionSheetController.addAction(nextAction)
        
        //Add a text field
        actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
            textField.placeholder = "Range to Cover"
        }
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    func createRestrictedZone(size : Int) {
        var zone = PFObject(className: "RestrictedZone")
        if let installation = (UIApplication.sharedApplication().delegate as! AppDelegate).installation {
            if let hash: NSNumber = (installation.objectForKey("hash")) as? NSNumber {
                zone.setObject(hash, forKey: "code")
                
            }
        }

        zone.setObject(size, forKey: "size")
        var mapVC = tabBarController?.viewControllers?.first as! MapViewController
        var position = mapVC.locationManager.location.coordinate
        var latitude = position.latitude
        var longitude = position.longitude
        zone.setObject(latitude, forKey: "latitude")
        zone.setObject(longitude, forKey: "longitude")
        zone.saveEventually()

    }

}
