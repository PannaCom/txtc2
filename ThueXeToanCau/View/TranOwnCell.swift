//
//  TranOwnCell.swift
//  ThueXeToanCau
//
//  Created by Hoang Tuan Anh on 4/13/17.
//  Copyright © 2017 AnhHT. All rights reserved.
//

import UIKit

class TranOwnCell: UITableViewCell {

    @IBOutlet weak var moneyMonthLabel: UILabel!
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var moneyPeriodLabel: UILabel!
    @IBOutlet weak var datePeriodLabel: UILabel!
    @IBOutlet weak var moneyYearLabel: UILabel!
    @IBOutlet weak var dateYearLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateUI(tranOwn: TranOwn) {
        moneyMonthLabel.text = tranOwn.moneyMonth
        moneyPeriodLabel.text = tranOwn.moneyPeriod
        moneyYearLabel.text = tranOwn.moneyYear
        
        dateMonthLabel.text = tranOwn.dateMonth
        datePeriodLabel.text = tranOwn.datePeriod
        dateYearLabel.text = tranOwn.dateYear
    }

}
