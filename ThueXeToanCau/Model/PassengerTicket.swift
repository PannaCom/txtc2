//
//  PassengerTicket.swift
//  ThueXeToanCau
//
//  Created by VMio69 on 12/28/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import Foundation
import SwiftyJSON

class PassengerTicket {
    private var _hireType: String!
    private var _placeFrom: String!
    private var _placeTo: String!
    private var _carSize: String!
    private var _price: String!
    private var _dateFrom: String!
    private var _dateTo: String!

    private var _id: String!

    var hireType: String {
        return _hireType
    }

    var placeFrom: String {
        return _placeFrom
    }

    var placeTo: String {
        return _placeTo
    }

    var carSize: String {
        return _carSize
    }

    var price: String {
        return _price
    }

    var dateFrom: String {
        return _dateFrom
    }

    var dateTo: String {
        return _dateTo
    }

    var id: String {
        return _id
    }

    init(hireType: String, placeFrom: String, placeTo: String, carSize: String, price: String, dateFrom: String, dateTo: String) {
        _hireType = hireType
        _placeFrom = placeFrom
        _placeTo = placeTo
        _carSize = carSize
        _price = price
        _dateFrom = dateFrom
        _dateTo = dateTo
    }

    convenience init(withJSON json: JSON) {
        self.init(hireType: String(describing: json["car_hire_type"]), placeFrom: String(describing: json["car_from"]), placeTo: String(describing: json["car_to"]), carSize: String(describing: json["car_type"]), price: String(describing: json["current_price"]), dateFrom: String(describing: json["from_datetime"]), dateTo: String(describing: json["to_datetime"]))
        _id = String(describing: json["id"])

    }
}
