//
//  DriverLogin.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/17/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import TextFieldEffects
import RxSwift
import Alamofire
import RxCocoa
import KRProgressHUD
import SwiftMessages
import SwiftyJSON

class DriverLogin: UIViewController {

    @IBOutlet var phoneTextField: AkiraTextField!
    @IBOutlet var passTextFiled: AkiraTextField!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var createUserButton: UIButton!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Dismiss keyboard when tap out textfield
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

        phoneTextField.borderColor = STYLE_FORMAT.TEXT_FIELD_BORDER_COLOR
        passTextFiled.borderColor = STYLE_FORMAT.TEXT_FIELD_BORDER_COLOR

        backButton.rx.tap
            .subscribe(onNext: {
                self.view.endEditing(true)
                self .dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)

        let validPhoneObservable = phoneTextField.rx.text.orEmpty
            .map { $0.characters.count > 0}
            .shareReplay(1)

        let validPassObservable = passTextFiled.rx.text.orEmpty
            .map { $0.characters.count > 0}
            .shareReplay(1)

        let validEverythingObservable = Observable.combineLatest(validPassObservable, validPhoneObservable){
            $0 && $1
            }.shareReplay(1)

        validEverythingObservable
            .bindTo(loginButton.rx.isEnabled)
            .addDisposableTo(disposeBag)

        loginButton.rx.tap
            .subscribe(onNext: {
                KRProgressHUD.show(progressHUDStyle: .whiteColor, maskType: .white, activityIndicatorStyle: .black, message: "Đang đăng nhập")
                self.view.endEditing(true)

                AlamofireManager.sharedInstance.manager.request(URL_APP_API.LOGIN, method: HTTPMethod.post, parameters: ["phone" : self.phoneTextField.text!, "pass" : self.passTextFiled.text!], encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
                    KRProgressHUD.dismiss()
                    if response.result.isSuccess {
                        let values:Array = JSON(response.result.value!).arrayObject!
                        if values.count > 0 {
                            STATIC_DATA.DRIVER_INFO = values[0] as! Dictionary<String, Any?>

                            let userDefault = UserDefaults.standard
                            userDefault.set(self.phoneTextField.text!, forKey: DRIVER_INFO.PHONE)
                            userDefault.set(self.passTextFiled.text!, forKey: DRIVER_INFO.PASS)
                            userDefault.set(USER_ROLE.DRIVER, forKey: USER_DEFAULT_DATA.USER_ROLE)
                            userDefault.synchronize()

                            self.performSegue(withIdentifier: SEGUE_ID.LOGIN_TO_AUCTION, sender: self)
                        }
                        else {
                            SwiftMessages.show(title:"Không thể đăng nhập", message: "Kiểm tra lại thông tin đăng nhập", layout: .MessageViewIOS8, theme: .error)
                        }
                    }
                })
            })
            .addDisposableTo(disposeBag)
    }

}
