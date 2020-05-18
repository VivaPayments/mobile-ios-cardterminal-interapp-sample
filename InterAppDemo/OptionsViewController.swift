//
//  OptionsViewController.swift
//  InterAppDemo
//
//  Created by Evangelos Pittas on 23/12/19.
//  Copyright © 2019 Viva Wallet. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    class func instantiate() -> OptionsViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OptionsViewController") as! OptionsViewController
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
