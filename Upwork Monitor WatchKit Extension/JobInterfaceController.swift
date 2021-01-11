//
//  JobInterfaceController.swift
//  Upwork Monitor WatchKit Extension
//
//  Created by Sergei Zorko on 19/01/2020.
//  Copyright © 2020 Banarum. All rights reserved.
//


import WatchKit
import Foundation
import WatchConnectivity

class JobInterfaceController: WKInterfaceController {
    @IBOutlet weak var priceLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    @IBOutlet weak var workTitle: WKInterfaceLabel!
    
    let TODAY_SEGUE = "today_segue"
    let WEEK_SEGUE = "week_segue"
    let MONTH_SEGUE = "month_segue"
    
    var session : WCSession!;
    
    var segue = ""

    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        var dict = context as? NSDictionary
        
        if(WCSession.isSupported()){
            self.session = WCSession.default;
            self.session.delegate = self;
            self.session.activate();
        }
        
        if dict != nil {
            self.segue = dict!["segue"] as! String

            if segue == TODAY_SEGUE {
                workTitle.setText("Today")
                
            } else if segue == WEEK_SEGUE {
                workTitle.setText("Week")
               
                
            } else if segue == MONTH_SEGUE {
                workTitle.setText("Month")
            }
            
            
            self.requestData()
            
            
            
    
            //print(segue, data)
        }
        
        
        // Configure interface objects here.
    }
    
    func requestData() {
        let accessToken = DBHelper.shared.getString(forKey: DBHelper.UPWORK_ACCESS_TOKEN)
        let accessTokenSecret = DBHelper.shared.getString(forKey: DBHelper.UPWORK_ACCESS_SECRET)
        
        // If oauth tokens present, proceed to Dashboard
        if accessToken != nil, accessTokenSecret != nil {
            print("YESTOKEN))")
            // Setup network Service
            APIService.shared.setTokens(accessToken: accessToken!, accessTokenSecret: accessTokenSecret!)
            self.getUserInfo()
        } else {
            print("NOTOKEN((")
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func getUserInfo() {
        APIService.shared.getUser(callback: {userResponse -> Void in
            if userResponse.status == APIService.API_OK {
                self.getIncome(user: userResponse.result!)
                
            } else {
                print(userResponse.message!)
            }
        })
    }
    
    // Request summarized income data for day/week/month
    func getIncome(user: User) {
        var income = Income(charge: 0, time: 0)
        
        if segue == TODAY_SEGUE {
            // Request Today income data
            
            
                  
           let today_start_timestamp = String(Int(Date().timeIntervalSince1970))
           let today_end_timestamp = String(Int(Date().timeIntervalSince1970))
           
           APIService.shared.getIncome(from: today_start_timestamp, till: today_end_timestamp, provider_id: user.profile_key) { (response) in
               if response.status == APIService.API_OK {
                   income = response.result!
                self.priceLabel.setText(income.getCharge())
                self.timeLabel.setText(income.getTime())
               } else {
                   print(response.message!)
               }
           }
            
        } else if segue == WEEK_SEGUE {
            
            // Request Week income data
            
            let week_start_timestamp = String(Int(Date().startOfWeek().timeIntervalSince1970))
            let week_end_timestamp = String(Int(Date().endOfWeek().timeIntervalSince1970))
            
            APIService.shared.getIncome(from: week_start_timestamp, till: week_end_timestamp, provider_id: user.profile_key) { (response) in
                if response.status == APIService.API_OK {
                    income = response.result!
                    self.priceLabel.setText(income.getCharge())
                    self.timeLabel.setText(income.getTime())
                } else {
                    print(response.message!)
                }
            }
            
        } else if segue == MONTH_SEGUE {
            
            // Request Month income data
            
            let month_start_timestamp = String(Int(Date().startOfMonth().timeIntervalSince1970))
            let month_end_timestamp = String(Int(Date().endOfMonth().timeIntervalSince1970))
            
            APIService.shared.getIncome(from: month_start_timestamp, till: month_end_timestamp, provider_id: user.profile_key) { (response) in
                if response.status == APIService.API_OK {
                    income = response.result!
                    self.priceLabel.setText(income.getCharge())
                    self.timeLabel.setText(income.getTime())
                } else {
                    print(response.message!)
                }
            }
            
        }
        
    }
        
}

extension JobInterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
         //self.timeLabel.setText("WCSessionActivationState")
        print("WCSessionActivationState")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        //self.timeLabel.setText("RECEIVED MSG")
        print("RECEIVED MSG", message)
        
        DBHelper.shared.saveString(message["accessToken"] as! String, forKey: DBHelper.UPWORK_ACCESS_TOKEN)
        DBHelper.shared.saveString(message["accessTokenSecret"] as! String, forKey: DBHelper.UPWORK_ACCESS_SECRET)
        
        self.requestData()
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("WATCH didReceiveApplicationContext")
        
        print(applicationContext)
        
       
    }
}
