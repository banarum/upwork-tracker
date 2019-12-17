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
        if tabBarIndex == 0 {
             print("DASHBOARD")
        } else if tabBarIndex == 1 {
            print("Jobs")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController!.delegate = self

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
