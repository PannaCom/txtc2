//
//  Driver.swift
//  ThueXeToanCau
//
//  Created by Hoang Tuan Anh on 4/15/17.
//  Copyright © 2017 AnhHT. All rights reserved.
//

import UIKit
import SwiftyJSON

class Driver: NSObject {
    private var _myId: String!
    private var _name: String!
    private var _phone: String!
    private var _email: String!
    private var _carModel: String!
    private var _carMade: String!
    private var _carYear: String!
    private var _carSize: String!
    private var _carNumer: String!
    private var _carType: String!
    private var _carPrice: String!
    private var _totalMoneys: String!
    private var _province: String!
    private var _dateTime: String!
    private var _code: String!
    private var _address: String!
    private var _cardIdentify: String!
    private var _license: String!
    private var _status: String!
    
    var myId: String {
        return _myId
    }
    
    var name: String {
        return _name
    }
    
    var phone: String {
        return _phone
    }
    
    var email: String {
        return _email
    }
    
    var carModel: String {
        return _carModel
    }
    
    var carMade: String {
        return _carMade
    }
    
    var carYear: String {
        return _carYear
    }
    
    var carSize: String {
        return _carSize + " "
    }
    
    var carNumber: String {
        return _carNumer
    }
    
    var carType: String {
        return _carType
    }
    
    var carPrice: String {
        return _carPrice
    }
    
    var totalMoneys: String {
        return _totalMoneys
    }
    
    var province: String {
        return _province
    }
    
    var dateTime: String {
        return _dateTime
    }
    
    var code: String {
        return _code
    }
    var address: String {
        return _address
    }
    
    var cardIdentify: String {
        return _cardIdentify
    }
    
    var license: String {
        return _license
    }
    
    var status: String {
        return _status
    }
    
    init(json: JSON) {
        _myId = json["id"].stringValue
        _name = json["name"].stringValue
        _phone = json["phone"].stringValue
        _email = json["email"].stringValue
        _carMade = json["car_made"].stringValue
        _carModel = json["car_model"].stringValue
        _carYear = json["car_years"].stringValue
        _carSize = json["car_size"].stringValue
        _carNumer = json["car_number"].stringValue
        _carType = json["car_type"].stringValue
        _carPrice = json["car_price"].stringValue
        _totalMoneys = json["total_moneys"].stringValue
        _province = json["province"].stringValue
        _dateTime = json["date_time"].stringValue
        _code = json["code"].stringValue
        _address = json["address"].stringValue
        _cardIdentify = json["card_identify"].stringValue
        _license = json["license"].stringValue
        _status = json["status"].stringValue
    }
}
