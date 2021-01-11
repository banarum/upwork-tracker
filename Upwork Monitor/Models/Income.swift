//
//  Income.swift
//  Upwork Monitor
//
//  Created by Sergei Zorko on 11/09/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import Foundation

struct Income: Codable {
    let charge: Float
    let time: Float
}

extension Income {
    func getTime() -> String {
        var hours = String(Int(self.time))
        var minutes = String(Int(self.time*60)%60)
        
        if hours.count == 1 {
            hours = "0\(hours)"
        }
        
        if minutes.count == 1 {
            minutes = "0\(minutes)"
        }
        
        return "\(hours):\(minutes)"
    }
    
    func getCharge(showNumberOnly: Bool = false) -> String {
        return showNumberOnly ? "\(Int(self.charge.rounded()))" : "$\(Int(self.charge.rounded()))"
    }
}
