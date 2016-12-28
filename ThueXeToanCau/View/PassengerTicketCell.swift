//
//  PassengerTicketCell.swift
//  ThueXeToanCau
//
//  Created by VMio69 on 12/28/16.
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
    @IBOutlet var priceLabel: UITextField!
    @IBOutlet var dateFromLabel: UITextField!
    @IBOutlet var dateToLabel: UITextField!
    var id: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateUI(passengerTicket: PassengerTicket) {
        hireTypeLabel.text = "Hình thức thuê: " + passengerTicket.hireType
        placeFromLabel.text = passengerTicket.placeFrom
        placeToLabel.text = passengerTicket.placeTo
        carSizeLabel.text = passengerTicket.carSize
        priceLabel.text = passengerTicket.price.customNumberStyle() + " đ"
        dateFromLabel.text = passengerTicket.dateFrom.serverDateTimeToFormatddMMhhmm()
        dateToLabel.text = passengerTicket.dateTo.serverDateTimeToFormatddMMhhmm()
        id = passengerTicket.id
    }

    @IBAction func bookingButtonTouchUp(_ sender: Any) {
        delegate?.passengerBooking(bookingId: id!)
    }
}
