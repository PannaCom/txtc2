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
    
    var date: Date {
        return _date.serverDateTimeToDate()
    }
    
    var money: String {
        return _money
    }
    
    init(json: JSON) {
        _content = String(describing: json["type"])
        _money = String(describing: json["money"])
        let dateString = String(describing: json["date"])
        let start = dateString.index(dateString.startIndex, offsetBy: 6)
        let end = dateString.index(dateString.endIndex, offsetBy: -2)
        let timeInterval: TimeInterval = Double.init(dateString.substring(with: start..<end))!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateDate = Date(timeIntervalSince1970: timeInterval)
        _date = dateFormatter.string(from: dateDate)
    }
    
}
