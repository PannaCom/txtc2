//
//  PassengerBookingResult.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/27/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class PassengerBookingResult: UIViewController {

    var result: Dictionary<String, String>?
    @IBOutlet var backButton: UIButton!
    @IBOutlet var doneButton: UIButton!

    @IBOutlet var namePhoneLabel: UILabel!
    @IBOutlet var placeFromLabel: UILabel!
    @IBOutlet var placeToLabel: UILabel!
    @IBOutlet var carTypeLabel: UILabel!
    @IBOutlet var hireTypeLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var noteLabel: UILabel!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.rx.tap
            .subscribe(onNext: {
                self.performSegue(withIdentifier: "fromPassengerBookingToPassengerSelectActivityUnwindSegueId", sender: self)
            })
            .addDisposableTo(disposeBag)
        doneButton.rx.tap
            .subscribe(onNext: {
                self.performSegue(withIdentifier: "fromPassengerBookingToPassengerSelectActivityUnwindSegueId", sender: self)
            })
            .addDisposableTo(disposeBag)

        namePhoneLabel.text = String.init(format: "\((result?["name"])!)\n\((result?["phone"])!)")
        placeFromLabel.text = result?["car_from"]
        placeToLabel.text = result?["car_to"]
        carTypeLabel.text = result?["car_type"]
        hireTypeLabel.text = result?["car_hire_type"]
        if result?["car_to"] == "Khứ hồi" || result?["car_hire_type"] == "Khứ hồi" {
            dateTimeLabel.text = String.init(format: " Đi: \((result?["from_datetime"])!)\n Về: \((result?["to_datetime"])!)")
        }
        else {
            dateTimeLabel.text = String.init(format: " Đi: \((result?["from_datetime"])!)")
        }

        distanceLabel.text = result?["distance"]
        priceLabel.text = result?["price"]
        noteLabel.text = result?["note"]
    }
}
