//
//  DriverBookingCell.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 1/1/17.
//  Copyright © 2017 AnhHT. All rights reserved.
//

import UIKit

class DriverBookingCell: UITableViewCell {

    @IBOutlet var idLabel: UILabel!
    @IBOutlet var placeFromLabel: UILabel!
    @IBOutlet var placeToLabel: UILabel!
    @IBOutlet var carSizeLabel: UILabel!
    @IBOutlet var dateFromLabel: UILabel!
    @IBOutlet var dateToLabel: UILabel!
    @IBOutlet var hireTypeLabel: UILabel!
    @IBOutlet var whoHireLabel: UILabel!
    var id: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateFromLabel.layer.borderWidth = 1
        dateFromLabel.layer.borderColor = UIColor.black.cgColor
        dateToLabel.layer.borderWidth = 1
        dateToLabel.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateUI(ticket: PassengerTicket) {
        hireTypeLabel.text = ticket.hireType
        //        timeCountDownLabel
        placeFromLabel.text = ticket.placeFrom
        placeToLabel.text = ticket.placeTo
        if ticket.carSize == "4" {
            carSizeLabel.text = "4 chỗ (giá siêu rẻ, không cốp)"
        }
        else {
            if ticket.carSize == "5" {
                carSizeLabel.text = "5 chỗ (có cốp)"
            }
            else {
                carSizeLabel.text = ticket.carSize + " chỗ"
            }
        }
        
        dateFromLabel.text = ticket.dateFrom.serverDateTimeTo(format: "dd/MM HH:mm")
        dateToLabel.text = ticket.dateTo.serverDateTimeTo(format: "dd/MM HH:mm")
        id = ticket.id
        idLabel.text = "#" + id!
        whoHireLabel.text = ticket.whoHire
    }

}
