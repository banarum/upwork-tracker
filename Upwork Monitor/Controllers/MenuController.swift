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
        
        let accessToken = DBHelper.shared.getString(forKey: DBHelper.UPWORK_ACCESS_TOKEN)
        let accessTokenSecret = DBHelper.shared.getString(forKey: DBHelper.UPWORK_ACCESS_SECRET)
        
        // If oauth tokens present, proceed to Dashboard
        if accessToken != nil, accessTokenSecret != nil {
            
            // Setup network Service
            APIService.shared.setTokens(accessToken: accessToken!, accessTokenSecret: accessTokenSecret!)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let dashboardController = storyBoard.instantiateViewController(withIdentifier: "dashboard") as! DashboardController
            self.navigationController?.setViewControllers([dashboardController], animated: false)
        }
    }

}
