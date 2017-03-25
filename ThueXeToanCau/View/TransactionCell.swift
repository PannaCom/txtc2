//
//  TransactionCell.swift
//  ThueXeToanCau
//
//  Created by Hoang Tuan Anh on 3/25/17.
//  Copyright © 2017 AnhHT. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(transaction: Transaction) {
        contentLabel.text = transaction.content
        dateLabel.text = transaction.date
        moneyLabel.text = transaction.money
    }

}
