//
//  JobItem.swift
//  Upwork Monitor
//
//  Created by Sergei Zorko on 11/12/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import Foundation

class JobItem {
    
    let title:String
    let clientName:String
    let budget:Float
    let claimed:Float
    let paid:Float
    let hours:Float
    let isFixed:Bool
    
    
    init(title: String, clientName: String, budget: Float, claimed: Float, paid: Float, isFixed:Bool, hours: Float = 0) {
        self.title = title
        self.clientName = clientName
        self.budget = budget
        self.claimed = claimed
        self.paid = paid
        self.hours = hours
        self.isFixed = isFixed
    }
}
