//
//  JobTableViewCell.swift
//  Upwork Monitor
//
//  Created by Sergei Zorko on 11/12/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {

    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var claimedRow: UIStackView!
    @IBOutlet weak var paidRow: UIStackView!
    @IBOutlet weak var budgetRow: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
