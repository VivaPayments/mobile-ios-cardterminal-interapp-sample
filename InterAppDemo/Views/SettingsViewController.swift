//
//  SettingsViewController.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 5/8/20.
//  Copyright © 2020 Viva Wallet. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var showReceiptSwitch: UISwitch!
    @IBOutlet weak var showRatingSwitch: UISwitch!


    override func viewDidLoad() {
        super.viewDidLoad()
        showReceiptSwitch.isOn = UserDefaults.standard.value(forKey: "show_receipt") as? Bool ?? true
        showRatingSwitch.isOn = UserDefaults.standard.value(forKey: "show_rating") as? Bool ?? true
    }
    
    
    @IBAction func showReceiptSwitchTapped(_ sender: Any) {
        UserDefaults.standard.set(showReceiptSwitch.isOn, forKey: "show_receipt")
        UserDefaults.standard.synchronize()
    }
    

    @IBAction func showRatingSwitchTapped(_ sender: Any) {
        UserDefaults.standard.set(showRatingSwitch.isOn, forKey: "show_rating")
        UserDefaults.standard.synchronize()
    }
}

