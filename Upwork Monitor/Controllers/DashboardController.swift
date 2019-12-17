//
//  DashboardController.swift
//  Upwork Monitor
//
//  Created by Sergei Zorko on 09/09/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import UIKit

class DashboardController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var valuesToggle: UISegmentedControl!
    
    @IBAction func onToggle(_ sender: UISegmentedControl) {
        updateUI()
    }
    
    var todayIncome = Income(charge: 0, time: 0) {
        didSet {
            updateUI()
        }
    }
    
    var weekIncome = Income(charge: 0, time: 0) {
        didSet {
            updateUI()
        }
    }
    
    var monthIncome = Income(charge: 0, time: 0) {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.todayIncome = Income(charge: 0, time: 0)
        self.weekIncome = Income(charge: 0, time: 0)
        self.monthIncome = Income(charge: 0, time: 0)

        // Make rounded profile picture
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        checkAssertions()
    }
    
    @IBAction func onSignOut(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Sing Out", message:
            "Are you sure?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ -> Void in
            
            // Delete tokens from local storage
            DBHelper.shared.deleteString(forKey: DBHelper.UPWORK_ACCESS_TOKEN)
            DBHelper.shared.deleteString(forKey: DBHelper.UPWORK_ACCESS_SECRET)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let menuController = storyBoard.instantiateViewController(withIdentifier: "menu") as! MenuController
            menuController.hidesBottomBarWhenPushed = true
            self.navigationController?.setViewControllers([menuController], animated: false)
            
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getUserInfo() {
        APIService.shared.getUser(callback: {userResponse -> Void in
            if userResponse.status == APIService.API_OK {
                self.setProfilePic(url: userResponse.result!.portrait_100_img)
                self.nameLabel.text = "\(userResponse.result!.first_name) \(userResponse.result!.last_name)"
                self.emailLabel.text = userResponse.result!.email
                self.getIncome(user: userResponse.result!)
                
            } else {
                print(userResponse.message!)
            }
        })
    }
    
    // Download and setup profile image
    func setProfilePic(url: String) {
        let imageURL = URL(string: url)!
        URLSession.shared.dataTask(with: imageURL) { (data, _, _) in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
        }.resume()
    }
    
    // Request summarized income data for day/week/month
    func getIncome(user: User) {
        self.todayIncome = Income(charge: 0, time: 0)
        self.weekIncome = Income(charge: 0, time: 0)
        self.monthIncome = Income(charge: 0, time: 0)
        
        // Request Today income data
       
        let today_start_timestamp = String(Int(Date().timeIntervalSince1970))
        let today_end_timestamp = String(Int(Date().timeIntervalSince1970))
        
        APIService.shared.getIncome(from: today_start_timestamp, till: today_end_timestamp, provider_id: user.profile_key) { (response) in
            if response.status == APIService.API_OK {
                self.todayIncome = response.result!
            } else {
                print(response.message!)
            }
        }
        
        // Request Week income data
        
        let week_start_timestamp = String(Int(Date().startOfWeek().timeIntervalSince1970))
        let week_end_timestamp = String(Int(Date().endOfWeek().timeIntervalSince1970))
        
        APIService.shared.getIncome(from: week_start_timestamp, till: week_end_timestamp, provider_id: user.profile_key) { (response) in
            if response.status == APIService.API_OK {
                self.weekIncome = response.result!
            } else {
                print(response.message!)
            }
        }
        
        // Request Month income data
        
        let month_start_timestamp = String(Int(Date().startOfMonth().timeIntervalSince1970))
        let month_end_timestamp = String(Int(Date().endOfMonth().timeIntervalSince1970))
        
        APIService.shared.getIncome(from: month_start_timestamp, till: month_end_timestamp, provider_id: user.profile_key) { (response) in
            if response.status == APIService.API_OK {
                self.monthIncome = response.result!
            } else {
                print(response.message!)
            }
        }
    }
    
    // Update data considering toggle position
    func updateUI() {
        if valuesToggle.selectedSegmentIndex == 0 {
            todayLabel.text = todayIncome.getCharge()
            weekLabel.text = weekIncome.getCharge()
            monthLabel.text = monthIncome.getCharge()
        } else {
            todayLabel.text = todayIncome.getTime()
            weekLabel.text = weekIncome.getTime()
            monthLabel.text = monthIncome.getTime()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let accessToken = DBHelper.shared.getString(forKey: DBHelper.UPWORK_ACCESS_TOKEN)
        let accessTokenSecret = DBHelper.shared.getString(forKey: DBHelper.UPWORK_ACCESS_SECRET)
        
        // If oauth tokens not present, redirect to Menu
        if accessToken != nil, accessTokenSecret != nil {
            
            // Setup network Service
            APIService.shared.setTokens(accessToken: accessToken!, accessTokenSecret: accessTokenSecret!)
            
            self.getUserInfo()
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let menuController = storyBoard.instantiateViewController(withIdentifier: "menu") as! MenuController
            menuController.hidesBottomBarWhenPushed = true
            self.navigationController?.setViewControllers([menuController], animated: false)
        }
    }
    
    func checkAssertions() {
        assert(nameLabel != nil)
        assert(emailLabel != nil)
        assert(profileImageView != nil)
        assert(todayLabel != nil)
        assert(weekLabel != nil)
        assert(monthLabel != nil)
        assert(valuesToggle != nil)
    }
    
}

// Add extension to correctly handle date frames
extension Date {
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func startOfWeek() -> Date {
        let gregorian = Calendar.current
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: 1, to: sunday!)!
    }
    
    func endOfWeek() -> Date {
        let gregorian = Calendar.current
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: 7, to: sunday!)!
    }
}
