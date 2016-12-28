//
//  DriverBooking.swift
//  ThueXeToanCau
//
//  Created by VMio69 on 12/17/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import RxSwift

class DriverBooking: UIViewController {

    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.rx.tap
            .subscribe(onNext: {self .dismiss(animated: true, completion: nil)})
            .addDisposableTo(DisposeBag())
    }

}

