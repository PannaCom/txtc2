//
//  DriverLogin.swift
//  ThueXeToanCau
//
//  Created by VMio69 on 12/17/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import TextFieldEffects
import RxSwift

class DriverLogin: UIViewController {

    @IBOutlet var phoneTextField: AkiraTextField!
    @IBOutlet var passTextFiled: AkiraTextField!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var createUserButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.placeholderColor = UIColor.darkGray
        phoneTextField.borderColor = UIColor.green
        passTextFiled.placeholderColor = UIColor.darkGray
        passTextFiled.borderColor = UIColor.green

        backButton.rx.tap
            .subscribe(onNext: {self .dismiss(animated: true, completion: nil)})
            .addDisposableTo(DisposeBag())
    }

}
