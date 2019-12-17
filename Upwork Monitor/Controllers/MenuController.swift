//
//  ViewController.swift
//  Upwork Monitor
//
//  Created by Sergei Zorko on 03/09/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import UIKit

class MenuController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "oauth_access_token") != nil {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let dashboardController = storyBoard.instantiateViewController(withIdentifier: "dashboard") as! DashboardController
            self.navigationController?.setViewControllers([dashboardController], animated: false)
        }
    }


}

