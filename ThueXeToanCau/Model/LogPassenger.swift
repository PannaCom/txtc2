//
//  LogPassenger.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 1/2/17.
//  Copyright © 2017 AnhHT. All rights reserved.
//

import UIKit
import SwiftyJSON
class LogPassenger: NSObject {
    private var _id: String!
    private var _name: String!
    private var _phone: String!
    private var _dateBooking: String!

    var id: String {
        return _id
    }

    var name: String {
        return _name
    }

    var phone: String {
        return _phone
    }

    var dateBooking: String {
        return _dateBooking
    }

    init(json: JSON) {
        _id = String(describing: json["id"])
        _name = String(describing: json["name"])
        _phone = String(describing: json["phone"])
        _dateBooking = String(describing: json["date_time"])
    }
}
