//
//  SettingsTableViewController.swift
//  Quadradinho D8
//
//  Created by Daniel Amarante on 5/8/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit
import StoreKit

class SettingsTableViewController: UITableViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    
    var product_id: NSString?;
    
    
    
    override func viewDidLoad() {
        
        product_id = "QD8";
        
        super.viewDidLoad()
        println("entroooou")
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        
        //addBotton();
        
    }
    
    
    @IBAction func buyNowButton(sender: AnyObject) {
        
        buyConsumable()
        
    }
    
    
    
    
    func buyConsumable(){
        
        println("About to fetch the products");
        
        // We check that we are allow to make the purchase.
        
        if (SKPaymentQueue.canMakePayments())
            
        {
            
            var productID:NSSet = NSSet(object: self.product_id!);
            
            var productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>);
            
            productsRequest.delegate = self;
            
            productsRequest.start();
            
            println("Fething Products");
            
        }else{
            
            println("can't make purchases");
            
        }
        
    }
    
    
    
    // Helper Methods
    
    
    
    func buyProduct(product: SKProduct){
        
        println("Sending the Payment Request to Apple");
        
        var payment = SKPayment(product: product)
        
        SKPaymentQueue.defaultQueue().addPayment(payment);
        
        
        
    }
    
    
    
    
    
    // Delegate Methods for IAP
    
    
    
    func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        
        println("got the request from Apple")
        
        var count : Int = response.products.count
        
        if (count>0) {
            
            var validProducts = response.products
            
            var validProduct: SKProduct = response.products[0] as! SKProduct
            
            if (validProduct.productIdentifier == self.product_id) {
                
                println(validProduct.localizedTitle)
                
                println(validProduct.localizedDescription)
                
                println(validProduct.price)
                
                buyProduct(validProduct);
                
            } else {
                
                println(validProduct.productIdentifier)
                
            }
            
        } else {
            
            println("nothing")
            
        }
        
    }
    
    
    
    
    
    func request(request: SKRequest!, didFailWithError error: NSError!) {
        
        println("La vaina fallo");
        
    }
    
    
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!)    {
        
        println("Received Payment Transaction Response from Apple");
        
        
        
        for transaction:AnyObject in transactions {
            
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                
                switch trans.transactionState {
                    
                case .Purchased:
                    
                    println("Product Purchased");
                    
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    break;
                    
                case .Failed:
                    
                    println("Purchased Failed");
                    
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    break;
                    
                    // case .Restored:
                    
                    //[self restoreTransaction:transaction];
                    
                default:
                    
                    break;
                    
                }
                
            }
            
        }
        
        
        
    }
    

}
