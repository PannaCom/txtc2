//
//  DriverBookingMap.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/20/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import RxSwift

class DriverBookingMap: UIViewController {

    @IBOutlet var backButton: UIButton!

    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.rx.tap
            .subscribe(onNext: {self .dismiss(animated: true, completion: nil)})
            .addDisposableTo(disposeBag)
    }
    
}
