//
//  AppDelegate.swift
//  Quadradinho D8
//
//  Created by Adriano Soares on 06/05/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit
import Bolts
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let tintColor         = UIColor(red: 225/255, green: 150/255, blue: 255/255, alpha: 1) //
    let selectedTintColor = UIColor.whiteColor() //
    
    var installation: PFInstallation?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UITabBar.appearance().tintColor = selectedTintColor
        
        
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("Cj5t1ox3NbECcKmvkSrihm0QHZxV9NLXAGAdNGAd",
            clientKey: "gY9pgUeU6qOaJdw74Z8fmEg1JTKwCdK8IUFjrU55")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        if let launchOptions = launchOptions {
            PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        } else {
            PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(["":""])
        }
        installation = PFInstallation.currentInstallation()
        installation!.saveInBackgroundWithBlock { (success, error) -> Void in
            var hash = (self.installation!.objectId!.hash as NSNumber).unsignedShortValue
            self.installation!.setObject(NSNumber(unsignedShort: hash), forKey: "hash")
            self.installation!.saveEventually()
        }

        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

