//
//  LogPassengerCell.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 1/2/17.
//  Copyright © 2017 AnhHT. All rights reserved.
//

import UIKit

class LogPassengerCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateBookingLabel: UILabel!
    var phone: String?
    var id: String?
    @IBOutlet var callButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateUI(logPassenger: LogPassenger) {
        self.id = logPassenger.id
        nameLabel.text = logPassenger.name
        self.phone = logPassenger.phone
        dateBookingLabel.text = logPassenger.dateBooking.serverDateTimeTo(format: "dd/MM/yyyy HH:mm")
    }

    @IBAction func callButtonTouched(_ sender: Any) {
        guard let number = URL(string: "telprompt://" + phone!) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(number)
        }
    }
}
