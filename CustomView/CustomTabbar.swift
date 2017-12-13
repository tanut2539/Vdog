//
//  CustomTabbar.swift
//  Vdog
//
//  Created by tanut2539 on 9/12/2560 BE.
//  Copyright © 2560 Development. All rights reserved.
//

import UIKit

class CustomTabbar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Itim-Regular", size: 12)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Itim-Regular", size: 12)!], for: .selected)
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
    }

}
