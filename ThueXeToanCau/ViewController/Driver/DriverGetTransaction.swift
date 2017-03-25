//
//  DriverGetTransaction.swift
//  ThueXeToanCau
//
//  Created by Hoang Tuan Anh on 24/03/2017.
//  Copyright © 2017 AnhHT. All rights reserved.
//

import UIKit
import M13Checkbox
import FSCalendar
import Alamofire
import SwiftyJSON
import SwiftMessages
import DropDown

class DriverGetTransaction: UIViewController, UITextFieldDelegate, FSCalendarDataSource, FSCalendarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var biensoTextField: UITextField!
    @IBOutlet weak var showDetailCheckbox: M13Checkbox!
    @IBOutlet weak var dateFromTextField: UITextField!
    @IBOutlet weak var dateToTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var transactions: Array<Transaction>!
    fileprivate weak var calendar: FSCalendar!
    var textFieldSelected: UITextField!
    var dateFromString: String! = ""
    var dateToString: String! = ""
    let carNumberDropDown = DropDown()
    var carNumberResults: Array<String>!
    let WIDTH_CONTENT = (SCREEN_WIDTH-40)/4-7
    
    override func loadView() {
        super.loadView()
        calendar = FSCalendar(frame: CGRect(x: 0, y: SCREEN_HEIGHT-SCREEN_WIDTH, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDetailCheckbox.stateChangeAnimation = .bounce(.fill)
        
        biensoTextField.delegate = self
        dateFromTextField.delegate = self
        dateToTextField.delegate = self
        
        self.view.addSubview(calendar);
        calendar.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        transactions = Array()
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
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightLabel(text: transactions[indexPath.row].content, font: UIFont.systemFont(ofSize: 15), width: WIDTH_CONTENT)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCellId", for: indexPath) as? TransactionCell {
            cell.updateUI(transaction: transactions[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    @IBAction func searchButtonTouched(_ sender: Any) {
        self.view.endEditing(true)
        calendar.isHidden = true
        var params:[String: String]
        if (biensoTextField.text?.isEmpty)! || (biensoTextField.text?.characters.count)! < 8 {
            SwiftMessages.show(title:"Lỗi", message: "Hãy nhập biển số xe", layout: .MessageViewIOS8, theme: .error)
            return
        }
        
        
        params = ["carNumber" : (biensoTextField?.text)!, "fDate" : (dateFromString)!, "tDate" : (dateToString)!, "isDetail" : showDetailCheckbox.checkState == M13Checkbox.CheckState.checked ? "true" : "false"]
        let headers = [
            "Content-Type" : "text/html; charset=utf-8"
        ]
        Alamofire.request(URL_APP_API.DRIVER_GET_TRANSACTION, method: .get, parameters: params, encoding: URLEncoding(), headers: headers).responseJSON(completionHandler: { response in
            
            if response.result.isSuccess {
                if let transResponse = JSON(response.result.value!).array {
                    self.transactions.removeAll()
                    for trans in transResponse {
                        let trans = Transaction(json: trans)
                        self.transactions.append(trans)
                    }
                    if self.transactions.count == 0 {
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
            Alamofire.request(URL_APP_API.SEARCH_CARNUMBER, method: .get, parameters: params, encoding: URLEncoding(), headers: headers).responseJSON(completionHandler: {
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
