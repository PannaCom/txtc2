//
//  Salary.swift
//  ThueXeToanCau
//
//  Created by Hoang Tuan Anh on 4/12/17.
//  Copyright © 2017 AnhHT. All rights reserved.
//

import UIKit
import SwiftyJSON

class Salary: NSObject {
    private var _myId: String!
    private var _money: String!
    private var _dateFrom: String!
    private var _dateTo: String!
    private var _bankNumber: String!
    private var _bankName: String!
    private var _carNumber: String!
    private var _driverName: String!
    
    var myId: String {
        return _myId
    }
    var money: String {
        return _money
    }
    
    var dateFrom: String {
        return _dateFrom
    }
    
    var dateTo: String {
        return _dateTo
    }
    
    var bankNumber: String {
        return _bankNumber
    }
    
    var bankName: String {
        return _bankName
    }
    
    var carNumber: String {
        return _carNumber
    }
    
    var driverName: String {
        return _driverName
    }
    
    init(json: JSON) {
        _myId = json["id"].stringValue
        _money = json["money"].stringValue.customNumberStyle()

        let serverDateFormatter = DateFormatter()
        serverDateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        _dateFrom = dateFormatter.string(from: serverDateFormatter.date(from: json["from_date"].stringValue)!)
        _dateTo = dateFormatter.string(from: serverDateFormatter.date(from: json["to_date"].stringValue)!)
        
        _bankNumber = json["bank_number"].stringValue
        _bankName = json["bank_name"].stringValue
        _carNumber = json["car_number"].stringValue
        _driverName = json["driver_name"].stringValue
    }
    
}
