//
//  DriverBooking.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/17/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import RxSwift

class DriverBooking: UIViewControllerCustom {

    @IBOutlet var backButton: UIButton!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.rx.tap
            .subscribe(onNext: {self .dismiss(animated: true, completion: nil)})
            .addDisposableTo(disposeBag)

        let subVc = TabsViewController(typeView: TYPE_VIEW.DRIVER_BOOKING)

        self.add(asChildViewController: subVc)

        NotificationCenter.default.addObserver(self, selector: #selector(bookingDone), name: Notification.Name(NOTIFICATION_STRING.DRIVER_BOOKING_DONE), object: nil)
    }

    func bookingDone() {
        self.dismiss(animated: true, completion: nil)
    }
}

