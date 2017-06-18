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
    private(set) var hireType: String!
    private(set) var placeFrom: String!
    private(set) var placeTo: String!
    private(set) var carSize: String!
    private(set) var priceCurrent: String!
    private(set) var dateFrom: String!
    private(set) var dateTo: String!

    private(set) var id: String!

    private(set) var lon1: String!
    private(set) var lat1: String!
    private(set) var lon2: String!
    private(set) var lat2: String!

    private(set) var dateBook: String!
    private(set) var priceBook: String!
    private(set) var whoHire: String!
    private(set) var priceMax: String!

    private(set) var priceBookDouble: Double!

    var dateFromDate: Date {
        return dateFrom.serverDateTimeToDate()
    }

    var dateBookDate: Date {
        return dateBook.serverDateTimeToDate()
    }

    var priceBookInt: Int {
        return Int(priceBook)!
    }
    
    var isBig: Bool {
        if priceBookInt < CONFIG_DATA.LIMIT_PRICE_CHANGE_TIME_AUCTION {
            return false
        }
        else {
            return true
        }
        
    }
    
    var timeEndAuctionBefore: TimeInterval {
        if isBig {
            return TimeInterval(-5*3600)
        }
        else {
            return TimeInterval(-3600)
        }
    }

    init(withJSON json: JSON) {
        hireType = String(describing: json["carhiretype"])
        placeFrom = String(describing: json["carfrom"])
        placeTo = String(describing: json["carto"])
        carSize = String(describing: json["cartype"])
        priceCurrent = String(describing: json["currentprice"])
        dateFrom = String(describing: json["fromdatetime"])
        dateTo = String(describing: json["todatetime"])
        id = String(describing: json["id"])
        lon1 = String(describing: json["lon1"])
        lat1 = String(describing: json["lat1"])
        lon2 = String(describing: json["lon2"])
        lat2 = String(describing: json["lat2"])
        dateBook = String(describing: json["datebook"])
        priceMax = String(describing: json["bookpricemax"])
        priceBook = String(describing: json["bookprice"])
        whoHire = String(describing: json["carwhohire"])
        priceBookDouble = json["bookprice"].doubleValue
    }
}
