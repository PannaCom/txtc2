//
//  DriverRegister.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/18/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import SwiftyJSON
import SwiftMessages
import DropDown
import KRProgressHUD

class DriverRegister: UIViewController, UITextFieldDelegate {

    @IBOutlet var backButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    @IBOutlet var confirmPassTextField: UITextField!
    @IBOutlet var identifyTextField: UITextField!
    @IBOutlet var licenseTextField: UITextField!
    @IBOutlet var carNumberTextField: UITextField!
    @IBOutlet var carMadeTextField: UITextField!
    @IBOutlet var carModelTextField: UITextField!
    @IBOutlet var carSizeTextField: UITextField!
    @IBOutlet var carYearTextField: UITextField!
    @IBOutlet var carTypeTextField: UITextField!

    let carMadeDropDown = DropDown()
    let carModelDropDown = DropDown()
    let carSizeDropDown = DropDown()
    let carYearDropDown = DropDown()
    let carTypeDropDown = DropDown()

    var carModelList = NSArray()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Dismiss keyboard when tap out textfield
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

        backButton.rx.tap
            .subscribe(onNext: {
                self.view.endEditing(true)
                self .dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)

        registerButton.rx.tap
            .subscribe(onNext: {
                if self.checkTextFieldEmpty() {
                    if self.checkPassword() {
                        var carSize = self.carSizeTextField.text!
                        carSize = carSize.substring(to: (carSize.range(of: " ")?.lowerBound)!)
                        let params:Dictionary<String, String> = ["name" : self.nameTextField.text!, "phone" : self.phoneTextField.text!, "pass" : self.passTextField.text!, "car_made" : self.carMadeTextField.text!, "car_model" : self.carModelTextField.text!, "car_size" : carSize, "car_year" : self.carYearTextField.text!, "car_number" : self.carNumberTextField.text!, "car_type" : self.carTypeTextField.text!, "card_identify" : self.identifyTextField.text!, "license" : self.licenseTextField.text!, "regId" : "test", "os" : DEVICE_OS.iOS]
                        print(params)
                        Alamofire.request(URL_APP_API.REGISTER_DRIVER, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
                            if response.result.isSuccess {
                                SwiftMessages.show(title: "", message: "Đăng ký thành công", layout: .StatusLine, theme: .success)
                            }
                            else {
                                SwiftMessages.show(title: "Lỗi:", message: "Đăng ký không thành công", layout: .MessageViewIOS8, theme: .error)
                            }
                        })
                    }
                }
                else {
                    SwiftMessages.show(title: "Lỗi", message: "Hãy điền đầy đủ thông tin", layout: .MessageViewIOS8, theme: .error)
                }
            })
            .addDisposableTo(disposeBag)

        carMadeTextField.delegate = self
        carModelTextField.delegate = self
        carYearTextField.delegate = self
        carTypeTextField.delegate = self
        carSizeTextField.delegate = self

        setupDropdown()

    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == carMadeTextField {
            carMadeDropDown.show()
            return false
        }
        if textField == carModelTextField {
            carModelDropDown.show()
            return false
        }
        if textField == carSizeTextField {
            carSizeDropDown.show()
            return false
        }
        if textField == carTypeTextField {
            carTypeDropDown.show()
            return false
        }
        if textField == carYearTextField {
            carYearDropDown.show()
            return false
        }
        return true
    }

    func checkPassword() -> Bool {
        if (passTextField.text?.characters.count)! < CONFIG_DATA.PASSWORD_MIN_LENGTH {
            SwiftMessages.show(title: "Lỗi: Mật khẩu quá ngắn", message: "Hãy nhập mật khẩu ít nhất có \(CONFIG_DATA.PASSWORD_MIN_LENGTH) ký tự", layout: .MessageViewIOS8, theme: .error)
            return false
        }
        if passTextField.text != confirmPassTextField.text {
            SwiftMessages.show(title: "Lỗi:", message: "Mật khẩu xác nhận không khớp", layout: .MessageViewIOS8, theme: .error)
            return false
        }
        return true
    }

    func checkTextFieldEmpty() -> Bool {
        return !((nameTextField.text?.isEmpty)!
            || (phoneTextField.text?.isEmpty)!
            || (passTextField.text?.isEmpty)!
            || (confirmPassTextField.text?.isEmpty)!
            || (carMadeTextField.text?.isEmpty)!
            || (carModelTextField.text?.isEmpty)!
            || (carSizeTextField.text?.isEmpty)!
            || (carYearTextField.text?.isEmpty)!
            || (carNumberTextField.text?.isEmpty)!
            || (carTypeTextField.text?.isEmpty)!
            || (identifyTextField.text?.isEmpty)!
            || (licenseTextField.text?.isEmpty)!
        )
    }

    func setupDropdownBasic(dropdown: DropDown, textField: UITextField) -> Void {
        dropdown.anchorView = textField
        dropdown.bottomOffset = CGPoint(x: 0, y: textField.bounds.height)
        dropdown.topOffset = CGPoint(x: 0, y: -dropdown.bounds.height - textField.bounds.height)
    }

    func setupDropdownBasics(dropdowns: NSArray, textFields: NSArray) -> Void {
        for i in 0...dropdowns.count-1 {
            setupDropdownBasic(dropdown: dropdowns[i] as! DropDown, textField: textFields[i] as! UITextField)
        }
    }

    func setupDropdown() {
        setupDropdownBasics(dropdowns: [carMadeDropDown, carModelDropDown, carSizeDropDown, carYearDropDown, carTypeDropDown], textFields: [carMadeTextField, carModelTextField, carSizeTextField, carYearTextField, carTypeTextField])

        carMadeDropDown.dataSource = STATIC_DATA.CAR_MADE as! [String]
        carMadeDropDown.selectionAction = { [unowned self] (index, item) in
            if self.carMadeTextField.text != item {
                self.view.endEditing(true)
                self.carMadeTextField.text = item
                self.carModelTextField.text = ""
                self.searchCarModel(for: item)
            }
        }

        carModelDropDown.dataSource = self.carModelList as! [String]
        carModelDropDown.selectionAction = { [unowned self] (index, item) in
            self.view.endEditing(true)
            self.carModelTextField.text = item
        }

        carSizeDropDown.dataSource = STATIC_DATA.CAR_SIZE as! [String]
        carSizeDropDown.selectionAction = { [unowned self] (index, item) in
            self.carSizeTextField.text = item
        }

        carTypeDropDown.dataSource = STATIC_DATA.CAR_TYPE as! [String]
        carTypeDropDown.selectionAction = { [unowned self] (index, item) in
            self.carTypeTextField.text = item
        }

        carYearDropDown.dataSource = STATIC_DATA.CAR_YEAR
        carYearDropDown.selectionAction = { [unowned self] (index, item) in
            self.carYearTextField.text = item
        }
    }

    func searchCarModel(for carMade: String) {
        KRProgressHUD.show(progressHUDStyle: .whiteColor, maskType: .white, activityIndicatorStyle: .black, message: "Đang tải dữ liệu")
        Alamofire.request(URL_APP_API.GET_CAR_MODEL, method: HTTPMethod.post, parameters: ["keyword" : carMade], encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
            KRProgressHUD.dismiss()
            if response.result.isSuccess {
                let r:NSArray = response.result.value as! NSArray
                self.carModelList = r.value(forKey: "name") as! NSArray
                self.carModelDropDown.dataSource = self.carModelList as! [String]
            }
            else {
                SwiftMessages.show(title: "Lỗi:", message: "Không thể tải Danh sách mẫu xe", layout: .MessageViewIOS8, theme: .error)
            }
        })
    }
}
