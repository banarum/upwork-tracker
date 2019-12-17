//
//  JobsViewController.swift
//  Upwork Monitor
//
//  Created by Sergei Zorko on 11/12/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import UIKit

class JobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var jobs = [JobItem]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.register(JobTableViewCell.self, forCellReuseIdentifier: "JobTableViewCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        
        loadSampleJobs()
        
        print("DONE")

        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jobs.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "JobTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? JobTableViewCell else {
                fatalError("The dequeued cell is not an instance of JobTableViewCell.")
        }
        
        let job = jobs[indexPath.row]
        
        print(indexPath, indexPath.row)
        
        cell.jobTitle.text = job.title
        cell.clientName.text = job.clientName
        
        (cell.claimedRow.arrangedSubviews[1] as! UILabel).text = "\(Int(job.claimed))$"
        (cell.paidRow.arrangedSubviews[1] as! UILabel).text = "\(Int(job.paid))$"
        
        if job.isFixed {
            (cell.budgetRow.arrangedSubviews[0] as! UILabel).text = "Budget"
            (cell.budgetRow.arrangedSubviews[1] as! UILabel).text = "\(Int(job.budget))$"
        }else{
            (cell.budgetRow.arrangedSubviews[0] as! UILabel).text = "Rate"
            (cell.budgetRow.arrangedSubviews[1] as! UILabel).text = "\(job.budget)$/h"
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // cell selected code here
    }
    
    private func loadSampleJobs() {
        let job1 = JobItem(
            title: "Develop food delivery application for a big delivery company",
            clientName: "John Doe",
            budget: 60,
            claimed: 500,
            paid: 23500,
            isFixed: false,
            hours: 300
        )
        
        let job2 = JobItem(
            title: "Fix bugs in our enterprise product dashboard. Experienced Laravel developer needed",
            clientName: "Martin Garrix",
            budget: 100,
            claimed: 1000,
            paid: 2300,
            isFixed: false,
            hours: 10
        )
        
        let job3 = JobItem(
            title: "Deploy my app",
            clientName: "Jahid Havaraghoe",
            budget: 5,
            claimed: 0,
            paid: 0,
            isFixed: true,
            hours: 0
        )
        
        self.jobs += [job1, job2, job3]
        
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
