//
//  Navigation.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 14/2/23.
//  Copyright © 2023 Viva Wallet. All rights reserved.
//

import UIKit

struct Navigation {

    static var rootVC: UIViewController? {
        return (
            UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        )?.window?.rootViewController
    }

}
