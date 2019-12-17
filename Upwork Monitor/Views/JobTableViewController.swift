//
//  JobTableViewController.swift
//  Upwork Monitor
//
//  Created by Sergei Zorko on 11/12/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import UIKit

class JobTableViewController: UITableViewController {
    
    var jobs = [JobItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleJobs()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jobs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? JobTableViewCell else {
                fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let job = jobs[indexPath.row]
        
        cell.jobTitle.text = job.title
        
        (cell.claimedRow.arrangedSubviews[1] as! UILabel).text = "\(job.claimed)$"
        (cell.paidRow.arrangedSubviews[1] as! UILabel).text = "\(job.paid)$"
        
        if job.isFixed {
            (cell.paidRow.arrangedSubviews[0] as! UILabel).text = "Budget"
            (cell.paidRow.arrangedSubviews[1] as! UILabel).text = "\(job.budget)$"
        }else{
            (cell.paidRow.arrangedSubviews[0] as! UILabel).text = "Rate"
            (cell.paidRow.arrangedSubviews[1] as! UILabel).text = "\(job.budget)$/h"
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
    
}
