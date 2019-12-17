//
//  RootController.swift
//  Upwork Monitor
//
//  Created by Sergei Zorko on 23/09/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import UIKit

class CabinetController: UIViewController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        // TODO: Handle Tabs
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController!.delegate = self

    }

}
