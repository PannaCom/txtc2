//
//  PassengerTicketCell.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/28/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit

protocol PassengerTicketDelegate {
    func passengerBooking(bookingId: String)
}

class PassengerTicketCell: UITableViewCell {

    var delegate: PassengerTicketDelegate?

    @IBOutlet var bookingButton: UIButton!
    @IBOutlet var hireTypeLabel: UILabel!
    @IBOutlet var placeFromLabel: UILabel!
    @IBOutlet var placeToLabel: UILabel!
    @IBOutlet var carSizeLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var dateFromLabel: UILabel!
    @IBOutlet var dateToLabel: UILabel!
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

    func updateUI(passengerTicket: PassengerTicket) {
        hireTypeLabel.text = "Hình thức thuê: " + passengerTicket.hireType
        placeFromLabel.text = passengerTicket.placeFrom
        placeToLabel.text = passengerTicket.placeTo
        if passengerTicket.carSize == "4" {
            carSizeLabel.text = "4 chỗ (giá siêu rẻ, không cốp)"
        }
        else {
            if passengerTicket.carSize == "5" {
                carSizeLabel.text = "5 chỗ (có cốp)"
            }
            else {
                carSizeLabel.text = passengerTicket.carSize + " chỗ"
            }
        }
        priceLabel.text = passengerTicket.priceMax.customNumberStyle() + " đ"
        dateFromLabel.text = passengerTicket.dateFrom.serverDateTimeTo(format: "dd/MM HH:mm")
        dateToLabel.text = passengerTicket.dateTo.serverDateTimeTo(format: "dd/MM HH:mm")
        id = passengerTicket.id
    }

    @IBAction func bookingButtonTouchUp(_ sender: Any) {
        delegate?.passengerBooking(bookingId: id!)
    }
}
