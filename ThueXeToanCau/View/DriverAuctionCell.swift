//
//  DriverAuctionCell.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/30/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import MZTimerLabel

protocol DriverAuctionDelegate {
    func buyNowButtonTouched(bookingId: String, priceBuy: String, timeRemain: TimeInterval)
    func auctionButtonTouched(bookingId: String, priceBuy: String, priceMax: String, timeRemain: TimeInterval)
}

class DriverAuctionCell: UITableViewCell, MZTimerLabelDelegate {

    var delegate: DriverAuctionDelegate?
    @IBOutlet var carHireTypeLabel: UILabel!
    @IBOutlet weak var timeCountDownLabel: MZTimerLabel!
    
    @IBOutlet var carFromLabel: UILabel!
    @IBOutlet var carToLabel: UILabel!
    @IBOutlet var carSizeLabel: UILabel!
    @IBOutlet var dateFromLabel: UILabel!
    @IBOutlet var dateToLabel: UILabel!
    @IBOutlet var priceBuyLabel: UILabel!
    @IBOutlet var priceAuction: UILabel!

    @IBOutlet var buyNowButton: UIButton!
    @IBOutlet var auctionButton: UIButton!


    var priceMax: String?
    var id: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateFromLabel.layer.borderWidth = 1
        dateFromLabel.layer.borderColor = UIColor.black.cgColor
        dateToLabel.layer.borderWidth = 1
        dateToLabel.layer.borderColor = UIColor.black.cgColor

        priceBuyLabel.layer.borderWidth = 1
        priceBuyLabel.layer.borderColor = UIColor.black.cgColor
        priceAuction.layer.borderWidth = 1
        priceAuction.layer.borderColor = UIColor.black.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateUI(ticket: PassengerTicket) {
        carHireTypeLabel.text = ticket.hireType
        carFromLabel.text = ticket.placeFrom
        carToLabel.text = ticket.placeTo
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
        priceBuyLabel.text = ticket.priceBook.customNumberStyle() + " đ"
        priceAuction.text = ticket.priceCurrent.customNumberStyle() + " đ"
        dateFromLabel.text = ticket.dateFrom.serverDateTimeTo(format: "dd/MM HH:mm")
        dateToLabel.text = ticket.dateTo.serverDateTimeTo(format: "dd/MM HH:mm")
        id = ticket.id

        if ticket.priceBookInt > CONFIG_DATA.LIMIT_PRICE_CHANGE_TIME_AUCTION {
            timeCountDownLabel.setCountDownTo(Date().addingTimeInterval(ticket.dateFromDate.addingTimeInterval(-5*3600).timeIntervalSince(Date.current())))
        }
        else {
            timeCountDownLabel.setCountDownTo(Date().addingTimeInterval(ticket.dateFromDate.addingTimeInterval(-3600).timeIntervalSince(Date.current())))
        }
        timeCountDownLabel.timerType = MZTimerLabelTypeTimer
        timeCountDownLabel.delegate = self
        timeCountDownLabel.start()
        priceMax = ticket.priceMax
    }

    @IBAction func buyNowButtonTouched(_ sender: Any) {
        let userDefault = UserDefaults.standard
        let nextTimeAuction:Date = userDefault.object(forKey: "nextTimeAuction") as! Date
        if Date() < nextTimeAuction {
            delegate?.buyNowButtonTouched(bookingId: "-2", priceBuy: "", timeRemain: timeCountDownLabel.getTimeRemaining())
        }
        else {
            if self.timeCountDownLabel.getTimeRemaining() <= 0 {
                delegate?.buyNowButtonTouched(bookingId: "-1", priceBuy: "", timeRemain: timeCountDownLabel.getTimeRemaining())
            }
            else {
                let priceBuy = priceBuyLabel.text!.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
                delegate?.buyNowButtonTouched(bookingId: id!, priceBuy: priceBuy.trimmingCharacters(in: CharacterSet.init(charactersIn: "0123456789").inverted), timeRemain: timeCountDownLabel.getTimeRemaining())
            }
        }
    }

    @IBAction func auctionButtonTouched(_ sender: Any) {
        let userDefault = UserDefaults.standard
        let nextTimeAuction:Date = userDefault.object(forKey: "nextTimeAuction") as! Date
        if Date() < nextTimeAuction {
            delegate?.auctionButtonTouched(bookingId: "-2", priceBuy: "", priceMax: "", timeRemain: timeCountDownLabel.getTimeRemaining())
        }
        else {
            if self.timeCountDownLabel.getTimeRemaining() <= 0 {
                delegate?.auctionButtonTouched(bookingId: "-1", priceBuy: "", priceMax: "", timeRemain: timeCountDownLabel.getTimeRemaining())
            }
            else {
                let priceBuy = priceBuyLabel.text!.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
                delegate?.auctionButtonTouched(bookingId: id!, priceBuy: priceBuy.trimmingCharacters(in: CharacterSet.init(charactersIn: "0123456789").inverted), priceMax: priceMax!, timeRemain: timeCountDownLabel.getTimeRemaining())
            }
        }
    }
    
    func timerLabel(_ timerLabel: MZTimerLabel!, customTextToDisplayAtTime time: TimeInterval) -> String! {
        let seconds = time.truncatingRemainder(dividingBy: 60)
        let minutes = (time / 60).truncatingRemainder(dividingBy: 60)
        let hours = time / 3600
        return String(format: "%02.0f:%02.0f:%02.0f", hours, minutes, seconds)
    }

}
