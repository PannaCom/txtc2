//
//  DriverGetSalary.swift
//  ThueXeToanCau
//
//  Created by Hoang Tuan Anh on 4/13/17.
//  Copyright © 2017 AnhHT. All rights reserved.
//

import UIKit
import FSCalendar
import Alamofire
import SwiftyJSON
import SwiftMessages
import DropDown
import RxCocoa
import RxSwift
import SCLAlertView

class DriverGetSalary: UIViewController, UITextFieldDelegate, FSCalendarDataSource, FSCalendarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var biensoTextField: UITextField!
    @IBOutlet weak var dateFromTextField: UITextField!
    @IBOutlet weak var dateToTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var salarys: Array<Salary>!
    var textFieldSelected: UITextField!
    var dateFromString: String! = ""
    var dateToString: String! = ""
    let carNumberDropDown = DropDown()
    var carNumberResults: Array<String>!
    let WIDTH_CONTENT = (SCREEN_WIDTH-40)/4-7
    
    private weak var calendar: FSCalendar!
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        let calendar = FSCalendar(frame: CGRect(x: 0, y: SCREEN_HEIGHT-SCREEN_WIDTH, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = .white
        self.view.addSubview(calendar);
        self.calendar = calendar
    }
    
    override func  viewDidLoad() {
        super.viewDidLoad()
        
        biensoTextField.delegate = self
        dateFromTextField.delegate = self
        dateToTextField.delegate = self
        
        backButton.rx.tap
            .subscribe(onNext: {self .dismiss(animated: true, completion: nil)})
            .addDisposableTo(disposeBag)
        
        calendar.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        salarys = Array()
        tableView.tableFooterView = UIView(frame: .zero)
        
        carNumberDropDown.anchorView = biensoTextField
        carNumberDropDown.bottomOffset = CGPoint(x: 0, y: biensoTextField.bounds.height)
        carNumberDropDown.topOffset = CGPoint(x: 0, y: -carNumberDropDown.bounds.height - biensoTextField.bounds.height)
        carNumberDropDown.selectionAction = { [unowned self] (index, item) in
            self.biensoTextField.text = item
        }
        carNumberResults = Array()
        
        biensoTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textFieldSelected = textField
        if textField == dateFromTextField || textField == dateToTextField{
            self.view.endEditing(true)
            self.calendar.isHidden = false
            return false
        }
        else {
            self.calendar.isHidden = true
        }
        return true
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy"
        textFieldSelected.text = dateformatter.string(from: date)
        dateformatter.dateFormat = "MM/dd/yyyy"
        if textFieldSelected == dateFromTextField {
            dateFromString = dateformatter.string(from: date)
        }
        else {
            dateToString = dateformatter.string(from: date)
        }
        self.calendar.isHidden = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salarys.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 40
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "salaryCellId", for: indexPath) as? SalaryCell {
            cell.updateUI(salary: salarys[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let appearance = SCLAlertView.SCLAppearance(
//            showCloseButton: true
//        )
        let alert = SCLAlertView()
        let rowSalary: Salary = salarys[indexPath.row]
        alert.showInfo("Chi tiết", subTitle: rowSalary.driverName + ", Số tài khoản: " + rowSalary.bankNumber + ", Ngân hàng: " + rowSalary.bankName)
    }
    
    @IBAction func searchButtonTouched(_ sender: Any) {
        self.view.endEditing(true)
        calendar.isHidden = true
        var params:[String: String]
        if (biensoTextField.text?.isEmpty)! || (biensoTextField.text?.characters.count)! < 8 {
            SwiftMessages.show(title:"Lỗi", message: "Hãy nhập biển số xe", layout: .MessageViewIOS8, theme: .error)
            return
        }
        
        
        params = ["carNumber" : (biensoTextField?.text)!, "fDate" : (dateFromString)!, "tDate" : (dateToString)!]
        let headers = [
            "Content-Type" : "text/html; charset=utf-8"
        ]
        Alamofire.request(URL_APP_API.SEARCH_TRAN_SALARY, method: .get, parameters: params, encoding: URLEncoding(), headers: headers).responseJSON(completionHandler: { response in
            
            if response.result.isSuccess {
                if let transResponse = JSON(response.result.value!).array {
                    self.salarys.removeAll()
                    for trans in transResponse {
                        let trans = Salary(json: trans)
                        self.salarys.append(trans)
                    }
                    if self.salarys.count == 0 {
                        SwiftMessages.show(title:"Không tìm thấy dữ liệu", message: "Hãy kiểm tra lại thông tin", layout: .MessageViewIOS8, theme: .warning)
                    }
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func textFieldDidChange(textField: UITextField) {
        if (biensoTextField.text?.characters.count)! > 0 {
            let headers = [
                "Content-Type" : "text/html; charset=utf-8"
            ]
            let params:[String:String] = ["keyword" : biensoTextField.text!]
            Alamofire.request(URL_APP_API.SEARCH_CARNUMBER_BANK, method: .get, parameters: params, encoding: URLEncoding(), headers: headers).responseJSON(completionHandler: {
                response in
                switch response.result {
                case .success(let value):
                    self.carNumberResults = JSON(value).arrayValue.map{$0.string!}
                    self.carNumberDropDown.dataSource = self.carNumberResults
                    self.carNumberDropDown.show()
                case .failure(let error):
                    print(error)
                }
            })
        }
        else {
            carNumberDropDown.hide()
        }
    }
    
    func heightLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height < 30 ? 30 : label.frame.height
        
    }
}
