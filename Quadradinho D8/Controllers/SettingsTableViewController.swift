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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        println(sender.on)
    }
    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    

*/
}
