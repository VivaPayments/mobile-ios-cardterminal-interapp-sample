//
//  CustomRequestViewController.swift
//  InterAppDemo
//
//  Created by Spyros Skordos on 1/4/22.
//  Copyright © 2022 Viva Wallet. All rights reserved.
//

import UIKit

class CustomRequestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubSwiftUIView(CustomRequestView(), to: self.view)
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
