//
//  Transaction.swift
//  ThueXeToanCau
//
//  Created by Hoang Tuan Anh on 23/03/2017.
//  Copyright © 2017 AnhHT. All rights reserved.
//

import Foundation
import SwiftyJSON
class Transaction: NSObject {
    private var _content: String!
    private var _date: String!
    private var _money: String!
    
    var content: String {
        return _content
    }
    
    var date: String {
        return _date
    }
    
    var money: String {
        return _money
    }
    
    init(json: JSON) {
        if !json["sum"].exists() {
            _content = String(describing: json["type"])
            _money = String(describing: json["money"])+"."
            _money = _money.substring(to: _money.characters.index(of: ".")!).customNumberStyle()
            let dateString = String(describing: json["date"])
            let start = dateString.index(dateString.startIndex, offsetBy: 6)
            let end = dateString.index(dateString.endIndex, offsetBy: -5)
            let timeInterval: TimeInterval = Double.init(dateString.substring(with: start..<end))!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy"
            let dateDate = Date(timeIntervalSince1970: timeInterval)
            _date = dateFormatter.string(from: dateDate)
        }
        else {
            _content = "Tổng Số Giao Dịch: " + String(describing: json["count"])
            _date = ""
            _money = String(describing: json["sum"])+"."
            _money = _money.substring(to: _money.characters.index(of: ".")!).customNumberStyle()
            
        }
    }
    
}
