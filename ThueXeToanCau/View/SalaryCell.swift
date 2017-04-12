//
//  SalaryCell.swift
//  ThueXeToanCau
//
//  Created by Hoang Tuan Anh on 4/13/17.
//  Copyright © 2017 AnhHT. All rights reserved.
//

import UIKit

class SalaryCell: UITableViewCell {

    @IBOutlet weak var dateFromLabel: UILabel!
    @IBOutlet weak var dateToLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateUI(salary: Salary) {
        dateFromLabel.text = salary.dateFrom
        dateToLabel.text = salary.dateTo
        moneyLabel.text = salary.money
    }

}
