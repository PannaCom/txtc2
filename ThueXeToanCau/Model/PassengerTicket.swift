//
//  PassengerTicket.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/28/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import Foundation
import SwiftyJSON

class PassengerTicket {
    private var _hireType: String!
    private var _placeFrom: String!
    private var _placeTo: String!
    private var _carSize: String!
    private var _priceCurrent: String!
    private var _dateFrom: String!
    private var _dateTo: String!

    private var _id: String!

    private var _lon1: String!
    private var _lat1: String!
    private var _lon2: String!
    private var _lat2: String!

    private var _dateBook: String!
    private var _priceBook: String!
    private var _whoHire: String!
    private var _priceMax: String!

    private(set) var priceBookDouble: Double!

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

    var priceCurrent: String {
        return _priceCurrent
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

    var lon1: String {
        return _lon1
    }

    var lat1: String {
        return _lat1
    }

    var lon2: String {
        return _lon2
    }

    var lat2: String {
        return _lat2
    }

    var dateBook: String {
        return _dateBook
    }

    var priceBook: String {
        return _priceBook
    }

    var priceMax: String {
        return _priceMax
    }

    var whoHire: String {
        return _whoHire
    }

    var dateFromDate: Date {
        return _dateFrom.serverDateTimeToDate()
    }

    var dateBookDate: Date {
        return _dateBook.serverDateTimeToDate()
    }


//    var dateToDate: Date {
//        return _dateTo.serverDateTimeToDate()
//    }

    var priceBookInt: Int {
        return Int(_priceBook)!
    }

    init(withJSON json: JSON) {
        _hireType = String(describing: json["car_hire_type"])
        _placeFrom = String(describing: json["car_from"])
        _placeTo = String(describing: json["car_to"])
        _carSize = String(describing: json["car_type"])
        _priceCurrent = String(describing: json["current_price"])
        _dateFrom = String(describing: json["from_datetime"])
        _dateTo = String(describing: json["to_datetime"])
        _id = String(describing: json["id"])
        _lon1 = String(describing: json["lon1"])
        _lat1 = String(describing: json["lat1"])
        _lon2 = String(describing: json["lon2"])
        _lat2 = String(describing: json["lat2"])
        _dateBook = String(describing: json["datebook"])
        _priceMax = String(describing: json["book_price_max"])
        _priceBook = String(describing: json["book_price"])
        _whoHire = String(describing: json["car_who_hire"])
        priceBookDouble = json["book_price"].doubleValue
    }
}
