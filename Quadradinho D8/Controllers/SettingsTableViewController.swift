//
//  SettingsTableViewController.swift
//  Quadradinho D8
//
//  Created by Daniel Amarante on 5/8/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var beaconSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beaconSwitch.addTarget(self, action: "switchTapped", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func switchTapped() {
        println(beaconSwitch.on)
    }

}
