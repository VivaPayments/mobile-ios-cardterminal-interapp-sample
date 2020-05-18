//
//  InterAppTabViewController.swift
//  InterAppDemo
//
//  Created by Alexandros Zat on 14/5/20.
//  Copyright © 2020 Viva Wallet. All rights reserved.
//

import UIKit

class InterAppTabViewController: UITabBarController {
    
    
    class func instantiate() -> InterAppTabViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InterAppTabViewController") as! InterAppTabViewController
        return vc
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "InterAppDemo"

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
