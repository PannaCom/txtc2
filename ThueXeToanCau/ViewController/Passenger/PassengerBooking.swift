//
//  PassengerBooking.swift
//  ThueXeToanCau
//
//  Created by VMio69 on 12/17/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class PassengerBooking: UIViewControllerCustom {

    @IBOutlet var backButton: UIButton!

    var resultBooking:Dictionary<String, String>?

    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.rx.tap
            .subscribe(onNext: {self .dismiss(animated: true, completion: nil)})
            .addDisposableTo(disposeBag)

        let subVc = TabsViewController(typeView: TYPE_VIEW.PASSENGER_BOOKING)

        self.add(asChildViewController: subVc)



    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(showBookingResult), name: Notification.Name(NOTIFICATION_STRING.PASSENGER_BOOKING_DONE), object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: Notification.Name(NOTIFICATION_STRING.PASSENGER_BOOKING_DONE), object: nil)
    }

    func showBookingResult(noti: Notification) {
        resultBooking = noti.object as! Dictionary<String, String>?
        self.performSegue(withIdentifier: "passengerBookingDoneSegueId", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passengerBookingDoneSegueId" {
            let vc:PassengerBookingResult = segue.destination as! PassengerBookingResult
            vc.result = resultBooking
        }
    }

}


