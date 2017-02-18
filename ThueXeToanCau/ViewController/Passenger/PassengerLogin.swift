//
//  PassengerLogin.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/17/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import TextFieldEffects
import RxSwift
import RxCocoa
import Alamofire

class PassengerLogin: UIViewController {

    @IBOutlet var nameTextField: AkiraTextField!
    @IBOutlet var phoneTextField: AkiraTextField!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var errorMessageLabel: UILabel!

    let disposeBag = DisposeBag()
    var isDriver = false

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.borderColor = STYLE_FORMAT.TEXT_FIELD_BORDER_COLOR
        phoneTextField.borderColor = STYLE_FORMAT.TEXT_FIELD_BORDER_COLOR

        backButton.rx.tap
            .subscribe(onNext: {self .dismiss(animated: true, completion: nil)})
            .addDisposableTo(disposeBag)

        let validNameObservable = nameTextField.rx.text.orEmpty
            .map { $0.characters.count > 1}
            .shareReplay(1)

        let validPhoneObservable = phoneTextField.rx.text.orEmpty
            .map { $0.characters.count > 9}
            .shareReplay(1)

        let validEverythingObservable = Observable.combineLatest(validNameObservable, validPhoneObservable){
            $0 && $1
        }.shareReplay(1)

        validNameObservable
            .bindTo(errorMessageLabel.rx.isHidden)
            .addDisposableTo(disposeBag)
        validPhoneObservable
            .bindTo(errorMessageLabel.rx.isHidden)
            .addDisposableTo(disposeBag)
        validEverythingObservable
            .bindTo(confirmButton.rx.isEnabled)
            .addDisposableTo(disposeBag)

        confirmButton.rx.tap
            .subscribe(onNext: {
                let userDefault = UserDefaults.standard
                userDefault.set(self.nameTextField.text, forKey: PASSENGER_INFO.NAME)
                userDefault.set(self.phoneTextField.text, forKey: PASSENGER_INFO.PHONE)
                if self.isDriver == true {
                    userDefault.set(USER_ROLE.DRIVER, forKey: USER_DEFAULT_DATA.USER_ROLE)
                }
                else {
                    userDefault.set(USER_ROLE.PASSENGER, forKey: USER_DEFAULT_DATA.USER_ROLE)
                }

                userDefault.synchronize()
                
                print("name:", self.nameTextField.text as Any)
                print("phone:", self.phoneTextField.text as Any)

                if self.isDriver == true {
                    let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = mainStoryboard.instantiateViewController(withIdentifier: STORYBOARD_ID.PASSENGER_BOOKING)
                    self.present(vc, animated: true, completion: nil)
                }
                else {
                    self.performSegue(withIdentifier: SEGUE_ID.PASSENGER_SELECT_ACTIVITY, sender: self)
                }

            })
            .addDisposableTo(disposeBag)
    }
}

