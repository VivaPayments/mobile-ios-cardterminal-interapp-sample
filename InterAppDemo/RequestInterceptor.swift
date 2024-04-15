//
//  RequestInterceptor.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 14/2/23.
//  Copyright © 2023 Viva Wallet. All rights reserved.
//

import UIKit

struct RequestInterceptor {

    @MainActor static func showRequestResult(url: URL, queryItems: [URLQueryItem]) {
        guard let stringDictionary = url.toStringDictionary() else { return }
        let response: InterAppResponse = InterAppResponse(stringDictionary: stringDictionary)
        let receipVC = ReceiptViewController.instantiate(response: response, parameters: queryItems)
        let nc = UINavigationController(rootViewController: receipVC)
        (((Navigation.rootVC as? UINavigationController)?.topViewController as? InterAppTabViewController)?
            .viewControllers?.first as? SaleViewController)?.update(isWaitingForResponse: false)
        Navigation.rootVC?.present(nc, animated: true, completion: nil)
    }

    static func performRequest(with actionURLString: String) {
        guard let url = URL(string: actionURLString) else { return }  // url with constructed parameters
        UIApplication.shared.open(url) { (result) in
            print("InterApp Request URL:\n", url)
            if result {
                // The URL was delivered successfully!
            }
        }
    }
}
