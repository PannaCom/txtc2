//
//  PassengerBookingInfo.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/18/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DateTimePicker
import GooglePlaces
import DropDown
import SCLAlertView
import Alamofire
import SwiftMessages

class PassengerBookingInfo: UIViewController, UITextFieldDelegate {

// MARK: --Properties, variables
    @IBOutlet var mainScroll: UIScrollView!

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!

    @IBOutlet var carHireTypeTextField: UITextField!
    @IBOutlet var placeFromTextField: UITextField!
    @IBOutlet var placeToTextField: UITextField!
    @IBOutlet var carTypeTextField: UITextField!
    @IBOutlet var whoHireTextField: UITextField!
    @IBOutlet var dateFromTextField: UITextField!
    @IBOutlet var dateToTextField: UITextField!

    @IBOutlet var bookingButton: UIButton!

    @IBOutlet var dateToLabel: UILabel!

    var textFieldSelected: UITextField!
    var airportTextField: UITextField!
    var airportHireTypeTextField: UITextField!

    let carHireTypeDropdown = DropDown()
    let carTypeDropdown = DropDown()
    let whoHireDropdown = DropDown()
    let airportDropdown = DropDown()
    let airportHireTypeDropdown = DropDown()
    let placeFromDropdown = DropDown()
    let placeToDropdown = DropDown()

    var fetcher: GMSAutocompleteFetcher?
    var gmsBounds: GMSCoordinateBounds?
    var gmsFilter: GMSAutocompleteFilter?
    var placeClient: GMSPlacesClient?
    var placeFromCoordinate: CLLocationCoordinate2D!
    var placeToCoordinate: CLLocationCoordinate2D!

    var fromLonString: String = ""
    var fromLatString: String = ""
    var toLonString: String = ""
    var toLatString: String = ""
    let disposeBag = DisposeBag()

    var placeData: NSArray?

    var dateTimeServerFormat: DateFormatter?
    var dateFromString: String = ""
    var dateToString: String = ""

    var dateToSampleDatetime: NSDate?
// MARK: --
    override func viewDidLoad() {
        super.viewDidLoad()
       
        formatTextFields(textFileds: [carHireTypeTextField, placeFromTextField, placeToTextField, carTypeTextField, whoHireTextField, dateFromTextField, dateToTextField])

        nameTextField.delegate = self
        phoneTextField.delegate = self
        placeFromTextField.delegate = self
        placeToTextField.delegate = self
        dateFromTextField.delegate = self
        dateToTextField.delegate = self
        carHireTypeTextField.delegate = self
        carTypeTextField.delegate = self
        whoHireTextField.delegate = self

        airportTextField = UITextField.init()
        airportHireTypeTextField = UITextField.init()

        let userDefault = UserDefaults.standard
        nameTextField.text = userDefault.string(forKey: PASSENGER_INFO.NAME)
        phoneTextField.text = userDefault.string(forKey: PASSENGER_INFO.PHONE)

        placeData = []

        gmsBounds = GMSCoordinateBounds.init(coordinate: GOOGLE_API.NORTH_EAST, coordinate: GOOGLE_API.SOUTH_WEST)
        gmsFilter = GMSAutocompleteFilter.init()
        gmsFilter?.country = "VN"

//         Create the fetcher.
        fetcher = GMSAutocompleteFetcher(bounds: gmsBounds, filter: gmsFilter)
        fetcher?.delegate = self

        placeClient = GMSPlacesClient.shared()
        placeFromTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        placeToTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)

        setupDropdown()

        dateTimeServerFormat = DateFormatter()
        dateTimeServerFormat?.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        dateTimeServerFormat?.locale = Locale.init(identifier: "en_US")

        bookingButton.rx.tap
            .subscribe(onNext: {

                if self.checkTextFieldEmpty() {
                    var carType:String = self.carTypeTextField.text!
                    carType = carType.substring(to: (carType.range(of: " ")?.lowerBound)!)
                    var airportName:String = ""
                    var airportWay:String = ""
                    if self.carHireTypeTextField.text! == "Sân bay" {
                        airportName = self.placeFromTextField.text!
                        airportWay = self.placeToTextField.text!
                    }

                    var dateTo:String = ""
                    if self.carHireTypeTextField.text == "Khứ hồi" || self.placeToTextField.text == "Khứ hồi" {
                        dateTo = self.dateToTextField.text!
                    }
                    else {
                        dateTo = (self.dateTimeServerFormat?.string(from: self.dateToSampleDatetime as! Date))!
                    }

                    let params:Dictionary<String, String> = ["car_from" : self.placeFromTextField.text!,
                                  "car_to" : self.placeToTextField.text!,
                                  "car_type" : carType,
                                  "car_hire_type" : self.carHireTypeTextField.text!,
                                  "car_who_hire" : self.whoHireTextField.text!,
                                  "from_datetime" : self.dateFromString,
                                  "to_datetime" : dateTo,
                                  "name" : self.nameTextField.text!,
                                  "phone" : self.phoneTextField.text!,
                                  "lon1" : self.fromLonString,
                                  "lat1" : self.fromLatString,
                                  "lon2" : self.toLonString,
                                  "lat2" : self.toLatString,
                                  "airport_name" : airportName,
                                  "airport_way" : airportWay]

                    Alamofire.request(URL_APP_API.BOOKING_TICKET, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseString { response in
                        print(response.result.value!)

                        if response.result.isFailure {
                            print("Error Load Data: \(response.result.error)")
                        }
                        if response.result.isSuccess {
                            let serverResponse = response.result.value?.characters.split(separator: Character.init("_")).map(String.init)
                            print(serverResponse!)

                            let priceMax:String = serverResponse![0].customNumberStyle() + " đồng"
                            let distance:String = serverResponse![1].customNumberStyle() + " km"
                            let priceBasic:String = serverResponse![2].customNumberStyle()
                            let pricePerDay:String = serverResponse![3].customNumberStyle()

                            let bookingResult:NSMutableDictionary = NSMutableDictionary.init(dictionary: params)
                            var note:String = ""
                            if self.carHireTypeTextField.text != "Sân bay" {
                                note = note + String.init(format: "- \(STATIC_DATA.NOTICE[0])\n- \(STATIC_DATA.NOTICE[1])\n")
                            }
                            if self.carHireTypeTextField.text == "Khứ hồi" {
                                note = note + String.init(format: "- Giá dựa trên giá cơ bản là \(priceBasic) đồng/km\n- Số tiền tính thêm khi đi quá 1 ngày là \(pricePerDay) đồng/ngày\n")
                            }
                            note = note + (STATIC_DATA.NOTICE[2] as! String)
                            bookingResult.setValue(note, forKey: "note")
                            bookingResult.setValue(distance, forKey: "distance")
                            bookingResult.setValue(priceMax, forKey: "price")
                            bookingResult.setValue(self.carTypeTextField.text!, forKey: "car_type")
                            NotificationCenter.default.post(name: Notification.Name(NOTIFICATION_STRING.PASSENGER_BOOKING_DONE), object: bookingResult)
                        }
                        else {
                            SwiftMessages.show(title: "Lỗi", message: "Hãy kiểm tra lại kết nội internet", layout: .MessageViewIOS8, theme: .error)
                        }

                    }
                }
                else {
                    SwiftMessages.show(title: "Lỗi", message: "Hãy điền đầy đủ thông tin", layout: .MessageViewIOS8, theme: .error)
                }
            })
            .addDisposableTo(disposeBag)


    }

    func checkTextFieldEmpty() -> Bool {
        if (dateToTextField.text?.isEmpty)! {
            if self.carHireTypeTextField.text == "Khứ hồi" || self.placeToTextField.text == "Khứ hồi" {
                return false
            }
        }
        return !((nameTextField.text?.isEmpty)!
            || (phoneTextField.text?.isEmpty)!
            || (carHireTypeTextField.text?.isEmpty)!
            || (placeFromTextField.text?.isEmpty)!
            || (placeToTextField.text?.isEmpty)!
            || (carTypeTextField.text?.isEmpty)!
            || (whoHireTextField.text?.isEmpty)!
            || (dateFromTextField.text?.isEmpty)!
            )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        carHireTypeTextField.text = ""
        placeFromTextField.text = ""
        placeToTextField.text = ""
        carTypeTextField.text = ""
        whoHireTextField.text = ""
        dateFromTextField.text = ""
        dateToTextField.text = ""
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    func setupDropdown() {
        setupDropdownBasics(dropdowns: [carHireTypeDropdown, carTypeDropdown, whoHireDropdown, placeFromDropdown, placeToDropdown], textFields: [carHireTypeTextField, carTypeTextField, whoHireTextField, placeFromTextField, placeToTextField])

        carHireTypeDropdown.dataSource = STATIC_DATA.CAR_HIRE_TYPE.subarray(with: NSRange.init(location: 0, length: 3)) as! [String]
        carHireTypeDropdown.selectionAction = { [unowned self] (index, item) in
            self.carHireTypeTextField.text = item

            if item == "Khứ hồi" {
                self.dateToTextField.isHidden = false
                self.dateToLabel.isHidden = false
            }
            else {
                self.dateToTextField.isHidden = true
                self.dateToLabel.isHidden = true
            }

            if item == "Sân bay" {
                self.placeFromTextField.isEnabled = false
                self.placeToTextField.isEnabled = false

                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alert = SCLAlertView(appearance: appearance)
                self.airportTextField = alert.addTextField("Sân bay")
                self.airportTextField.delegate = self
                self.airportHireTypeTextField = alert.addTextField("Hình thức")
                self.airportHireTypeTextField.delegate = self

                self.airportDropdown.anchorView = self.airportTextField
                self.airportDropdown.bottomOffset = CGPoint(x: 0, y: self.airportTextField.bounds.height)
                self.airportDropdown.topOffset = CGPoint(x: 0, y: -self.airportDropdown.bounds.height - self.airportTextField.bounds.height)
                let airportNames = STATIC_DATA.AIRPORT.map{($0 as! Airport).airportName}
                self.airportDropdown.dataSource = airportNames 
                self.airportDropdown.selectionAction = { [unowned self] (index, item) in
                    self.airportTextField.text = item
                }

                self.airportHireTypeDropdown.anchorView = self.airportHireTypeTextField
                self.airportHireTypeDropdown.bottomOffset = CGPoint(x: 0, y: self.airportHireTypeTextField.bounds.height)
                self.airportHireTypeDropdown.topOffset = CGPoint(x: 0, y: -self.airportHireTypeDropdown.bounds.height - self.airportHireTypeTextField.bounds.height)
                self.airportHireTypeDropdown.dataSource = ["Thành phố đi sân bay", "Sân bay về thành phố", "Khứ hồi"]
                self.airportHireTypeDropdown.selectionAction = { [unowned self] (index, item) in
                    self.airportHireTypeTextField.text = item

                    if item == "Khứ hồi" {
                        self.dateToTextField.isHidden = false
                        self.dateToLabel.isHidden = false
                    }
                    else {
                        self.dateToTextField.isHidden = true
                        self.dateToLabel.isHidden = true
                    }
                }

                let doneButton = alert.addButton("Xong") {
                    if (self.airportTextField.text?.characters.count)! > 0 && (self.airportHireTypeTextField.text?.characters.count)! > 0 {
                        self.placeFromTextField.text = self.airportTextField.text
                        self.placeToTextField.text = self.airportHireTypeTextField.text

                        let airPort = STATIC_DATA.AIRPORT.filter{ ($0 as AnyObject).airportName == self.airportTextField.text!}.first as! Airport

                        self.fromLonString = airPort.lon1
                        self.fromLatString = airPort.lat1
                        self.toLonString = airPort.lon2
                        self.toLatString = airPort.lat2

                        NotificationCenter.default.post(name: Notification.Name(NOTIFICATION_STRING.BOOKING_UPDATE_COORDINATE), object: ["fromCoordinate" : CLLocationCoordinate2D.init(latitude: Double.init(airPort.lat1)!, longitude: Double.init(airPort.lon1)!), "toCoordinate" : CLLocationCoordinate2D.init(latitude: Double.init(airPort.lat2)!, longitude: Double.init(airPort.lon2)!)])

                        alert.hideView()
                    }

                }

                self.airportTextField.rx.text
                    .subscribe(
                        onNext: { s in
                            if (s?.characters.count)! > 0 {
                                doneButton.isEnabled = true
                            }
                            else {
                                doneButton.isEnabled = true
                            }
                        },
                        onError: { e in

                        }
                    )
                    .addDisposableTo(self.disposeBag)

                self.airportHireTypeTextField.rx.text
                    .subscribe(
                        onNext: { s in
                            if (s?.characters.count)! > 0 {
                                doneButton.isEnabled = true
                            }
                            else {
                                doneButton.isEnabled = true
                            }
                        },
                            onError: { e in

                        }
                    )
                    .addDisposableTo(self.disposeBag)

                alert.showEdit("", subTitle: "Chọn sân bay, hình thức thuê")

            }
            else {
                self.placeFromTextField.isEnabled = true
                self.placeToTextField.isEnabled = true
            }
        }

        carTypeDropdown.dataSource = STATIC_DATA.CAR_SIZE as! [String]
        carTypeDropdown.selectionAction = { [unowned self] (index, item) in
            self.carTypeTextField.text = item
        }

        whoHireDropdown.dataSource = STATIC_DATA.WHO_HIRE as! [String]
        whoHireDropdown.selectionAction = { [unowned self] (index, item) in
            self.whoHireTextField.text = item
        }

        placeFromDropdown.dataSource = placeData as! [String]
        placeFromDropdown.selectionAction = { [unowned self] (index, item) in
            self.placeFromTextField.text = item
            self.view.endEditing(true)
            let r = self.placeData?.filtered(using: NSPredicate.init(format: "name = '\(item)'")).first as! NSDictionary
            let placeID: String = r.value(forKey: "id") as! String
            DispatchQueue.main.async {
                self.placeClient?.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
                    if let error = error {
                        print("lookup place id query error: \(error.localizedDescription)")
                        return
                    }

                    if let place = place {
                        print("Place coordinate \(place.coordinate)")
                        self.placeFromCoordinate = place.coordinate
                        self.fromLonString = String.init(format: "%.6f", self.placeFromCoordinate.longitude)
                        self.fromLatString = String.init(format: "%.6f", self.placeFromCoordinate.latitude)
                        NotificationCenter.default.post(name: Notification.Name(NOTIFICATION_STRING.BOOKING_UPDATE_COORDINATE), object: ["fromCoordinate" : place.coordinate])
                    } else {
                        print("No place details for \(placeID)")
                    }
                })
            }
        }

        placeToDropdown.dataSource = placeData as! [String]
        placeToDropdown.selectionAction = { [unowned self] (index, item) in
            self.placeToTextField.text = item
            self.view.endEditing(true)
            let r = self.placeData?.filtered(using: NSPredicate.init(format: "name = '\(item)'")).first as! NSDictionary
            let placeID: String = r.value(forKey: "id") as! String
            DispatchQueue.main.async {
                self.placeClient?.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
                    if let error = error {
                        print("lookup place id query error: \(error.localizedDescription)")
                        return
                    }

                    if let place = place {
                        print("Place coordinate \(place.coordinate)")
                        self.placeToCoordinate = place.coordinate
                        self.toLonString = String.init(format: "%.6f", self.placeToCoordinate.longitude)
                        self.toLatString = String.init(format: "%.6f", self.placeToCoordinate.latitude)
                        NotificationCenter.default.post(name: Notification.Name(NOTIFICATION_STRING.BOOKING_UPDATE_COORDINATE), object: ["toCoordinate" : place.coordinate])
                    } else {
                        print("No place details for \(placeID)")
                    }
                })
            }
        }
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

    func formatTextField(textField: UITextField) -> Void {
        textField.layer.borderColor = STYLE_FORMAT.TEXT_FIELD_BORDER_COLOR.cgColor
        textField.layer.borderWidth = 1
    }

    func formatTextFields(textFileds: NSArray) -> Void {
        for textField in textFileds {
            formatTextField(textField: textField as! UITextField)
        }
    }

// MARK: --UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textFieldSelected != textField {
            self.view.endEditing(true)
        }

        textFieldSelected = textField
        if textField == dateFromTextField || textField == dateToTextField {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM hh:mm a"

            let picker = DateTimePicker.show()
            picker.doneButtonTitle = "Xong"
            picker.todayButtonTitle = "Hôm nay"

            picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
            picker.completionHandler = { date in
                textField.text = dateFormatter.string(from: date)
                if self.textFieldSelected == self.dateFromTextField {
                    self.dateFromString = (self.dateTimeServerFormat?.string(from: date))!
                }
                if self.textFieldSelected == self.dateToTextField {
                    self.dateToString = (self.dateTimeServerFormat?.string(from: date))!
                }
                self.dateToSampleDatetime = date.addingTimeInterval(4000) as NSDate?
                picker.isHidden = true
            }
            return false
        }

        if textField == carHireTypeTextField || textField == carTypeTextField || textField == whoHireTextField {
            if textField == carHireTypeTextField {
                carHireTypeDropdown.show()
            }
            if textField == carTypeTextField {
                carTypeDropdown.show()
            }
            if textField == whoHireTextField {
                whoHireDropdown.show()
            }

            return false
        }

        if textField == airportTextField {
            airportDropdown.show()
            return false
        }

        if textField == airportHireTypeTextField {
            airportHireTypeDropdown.show()
            return false
        }

        return true
    }

    func textFieldDidChange(textField: UITextField) {
        fetcher?.sourceTextHasChanged(textField.text!)
    }
}

// MARK: - GMSAutocompleteFetcherDelegate
extension PassengerBookingInfo: GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        let r:NSMutableArray = []
        for prediction in predictions {
            r.add(["name":prediction.attributedFullText.string, "id":prediction.placeID as Any])
        }
        placeData = r
        if textFieldSelected == placeFromTextField {
            placeFromDropdown.dataSource = r.value(forKey: "name") as! [String]
            placeFromDropdown.show()
        }
        if textFieldSelected == placeToTextField {
            placeToDropdown.dataSource = r.value(forKey: "name") as! [String]
            placeToDropdown.show()
        }

        print(predictions)
    }

    func didFailAutocompleteWithError(_ error: Error) {
        print(error.localizedDescription)
    }
}


