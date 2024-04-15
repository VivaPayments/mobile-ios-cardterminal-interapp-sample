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
        vc.viewControllers?.insert(SaleViewController(), at: 0)
        vc.tabBar.items?[0].image = UIImage(systemName: "creditcard")
        vc.tabBar.items?[0].title = "Sale"
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "InterAppDemo"
    }
    
    @IBAction func abortButtonTapped(_ sender: Any) {
        //  "vivapayclient://pay/v1?callback=interapp-callback&merchantKey=SG23323424EXS3&appId=com.vivawallet.InterAppDemo&action=abort"
        RequestInterceptor.performRequest(with: Constants.abortUrlString)
    }
}
