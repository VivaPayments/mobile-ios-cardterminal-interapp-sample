//
//  AuthenticateViewController.swift
//  InterAppDemo
//
//  Created by Spyros Skordos on 11/3/22.
//  Copyright © 2022 Viva Wallet. All rights reserved.
//

import UIKit

class ActivationPOSViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubSwiftUIView(ActivationPOSView(), to: self.view)
        // Do any additional setup after loading the view.
    }

}
