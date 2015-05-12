//
//  SettingsTableViewController.swift
//  Quadradinho D8
//
//  Created by Daniel Amarante on 5/8/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit
import StoreKit

class SettingsTableViewController: UITableViewController, SKProductsRequestDelegate {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//        
//        
//        let productsRequest = SKProductsRequest(productIdentifiers: ["produto"])
//        productsRequest.delegate = self;
//        productsRequest.start();
    }
    
    override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
    }
    
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        
    }
    
//    @IBAction func premiumSelecter(sender: UISwitch) {
//                NSNotificationCenter.defaultCenter().postNotificationName ("transmitNotification", object:sender.on )
//                println(sender.on)
    //}
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
