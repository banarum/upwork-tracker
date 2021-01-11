//
//  InterfaceController.swift
//  Upwork Monitor WatchKit Extension
//
//  Created by Sergei Zorko on 03/09/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    /*@IBAction func onTodayClicked() {
        pushController(withName: "JobDescription", context: nil)
    }
    
    @IBAction func onWeekClicked() {
        pushController(withName: "JobDescription", context: nil)
    }
    
    @IBAction func onMonthClicked() {
        pushController(withName: "JobDescription", context: nil)
    }*/
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
            if segueIdentifier == "hierarchical" {
                return ["segue": "hierarchical",
                    "data":"Passed through hierarchical navigation"]
            } else if segueIdentifier == "pagebased" {
                return ["segue": "pagebased",
                    "data": "Passed through page-based navigation"]
            } else {
                return ["segue": segueIdentifier, "data": ""]
            }
    }

}
