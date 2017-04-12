//
//  TranOwn.swift
//  ThueXeToanCau
//
//  Created by Hoang Tuan Anh on 4/13/17.
//  Copyright © 2017 AnhHT. All rights reserved.
//

import UIKit
import SwiftyJSON

class TranOwn: NSObject {
    private var _myId: String!
    private var _moneyMonth: String!
    private var _dateMonth: String!
    private var _moneyPeriod: String!
    private var _datePeriod: String!
    private var _moneyYear: String!
    private var _dateYear: String!
    private var _carNumber: String!
    private var _driverName: String!
//    private var _date_time: String!
    
    var myId: String {
        return _myId
    }
    var moneyMonth: String {
        return _moneyMonth
    }
    
    var dateMonth: String {
        return _dateMonth
    }
    
    var moneyPeriod: String {
        return _moneyPeriod
    }
    
    var datePeriod: String {
        return _datePeriod
    }
    
    var moneyYear: String {
        return _moneyYear
    }
    
    var dateYear: String {
        return _dateYear
    }
    
    var carNumber: String {
        return _carNumber
    }
    
    var driverName: String {
        return _driverName
    }
    
//    var date_time: String {
//        return _date_time
//    }
    
    init(json: JSON) {
        _myId = json["id"].stringValue
        _moneyMonth = json["money_month"].stringValue.customNumberStyle()
        _moneyPeriod = json["money_period"].stringValue.customNumberStyle()
        _moneyYear = json["money_year"].stringValue.customNumberStyle()
        
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        _dateMonth = dateFormatter.string(from: serverDateFormatter.date(from: json["date_month"].stringValue)!)
        _datePeriod = dateFormatter.string(from: serverDateFormatter.date(from: json["date_period"].stringValue)!)
        _dateYear = dateFormatter.string(from: serverDateFormatter.date(from: json["date_year"].stringValue)!)
            
        _carNumber = json["car_number"].stringValue
        _driverName = json["driver_name"].stringValue
    }
}
