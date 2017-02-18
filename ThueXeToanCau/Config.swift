//
//  Config.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/17/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

// API
let HOSTNAME = "http://thuexetoancau.vn/"
struct URL_APP_API {
    static let GET_CAR_HIRE_TYPE = HOSTNAME + "api/getCarHireType"
    static let GET_CAR_SIZE = HOSTNAME + "api/getCarSize"
    static let GET_CAR_TYPE = HOSTNAME + "api/getListCarType"
    static let GET_CAR_MADE = HOSTNAME + "api/getCarMadeList"
    static let GET_CAR_MODEL = HOSTNAME + "api/getCarModelListFromMade"
    static let GET_WHO_HIRE = HOSTNAME + "api/getCarWhoHire"

    static let BOOKING_TICKET  = HOSTNAME + "api/booking"
    static let GET__BOOKING = HOSTNAME + "api/getBooking"
    static let BOOKING_FINAL = HOSTNAME + "api/bookingFinal"
    static let GET_BOOKING_SUCCESS = HOSTNAME + "api/getBookingSuccess"
    static let REGISTER_DRIVER = HOSTNAME + "api/driverRegister"
    static let GET_AIRPORT = HOSTNAME + "api/getAirportName"
    static let GET_LONLAT_AIRPORT  = HOSTNAME + "api/getLonLatAirport"
    static let LOGIN = HOSTNAME + "api/login"
    static let GET_NOTICE  = HOSTNAME + "api/getNotice"
    static let BOOKING_LOG = HOSTNAME + "api/bookingLog"
    static let GET_BOOKING_LOG = HOSTNAME + "api/getBookingLog"
    static let GET_BOOKING_CUSTOMER = HOSTNAME + "api/getBookingForCustomer"
    static let GET_LIST_BOOKING_LOG = HOSTNAME + "api/getlistbookinglog"
    static let GET_DRIVER_BY_ID = HOSTNAME + "api/getDriverById"
    static let GET_MONEY_DRIVER = HOSTNAME + "api/getMoneyDriver"
    static let WHO_WIN_DRIVER = HOSTNAME + "api/whoWin"
    static let CONFIRM_DRIVER = HOSTNAME + "api/confirm"
    static let POST_DRIVER_COORDINATE = HOSTNAME + "api/postDriverGPS"
    static let PASSENGER_GET_AROUND = HOSTNAME + "api/getAround"
}


struct PASSENGER_INFO{
    static let NAME = "namePassenger"
    static let PHONE = "phonePassenger"
}
struct DRIVER_INFO {
    static let ID = "id"
    static let NAME = "name"
    static let PHONE = "phone"
    static let PASS = "pass"
    static let EMAIL = "email"
    static let CAR_MODEL = "car_model"
    static let CAR_MADE = "car_made"
    static let CAR_YEAR = "car_years"
    static let CAR_SIZE = "car_size"
    static let CAR_NUMBER = "car_number"
    static let CAR_TYPE = "car_type"
    static let CAR_PRICE = "car_price"
    static let TOTAL_MONEY = "total_moneys"
    static let PROVINCE = "province"
    static let DATETIME = "date_time"
    static let CODE = "code"
    static let ADDRESS = "address"
    static let CARD_IDENTIFY = "card_identify"
    static let LICENSE = "license"
    static let REG_ID = "reg_id"
    static let STATUS = "status"
}
struct USER_DEFAULT_DATA {
    static let USER_ROLE = "userDefaultDataUserRole"
}

struct USER_ROLE{
    static let PASSENGER = "userRolePassenger"
    static let DRIVER = "userRoleDriver"
}

struct SEGUE_ID {
    static let PASSENGER_SELECT_ACTIVITY = "passengerSelectActivitySegueId"
    static let LOGIN_TO_AUCTION = "driverLoginToAuctionSegueId"
    static let SHOW_LOG_AUCTION_SUCCESS = "driverLogAuctionSuccess"
    static let SHOW_LOG_BOOKING = "driverLogBooking"
}

struct STORYBOARD_ID {
    static let PASSENGER_SELECT_ACTIVITY = "passengerSelectActivityStoryboardId"
    static let PASSENGER_LOGIN = "passengerLoginStoryboardId"
    static let PASSENGER_BOOKING = "passengerBookingStoryboardId"
    static let PASSENGER_BOOKING_INFO = "passengerBookingInfoStoryboardId"
    static let PASSENGER_BOOKING_MAP = "passengerBookingMapStoryboardId"
    static let PASSENGER_GET_BOOKING_INFO = "passengerGetBookingInfoStoryboardId"
    static let PASSENGER_GET_BOOKING_MAP = "passengerGetBookingMapStoryboardId"

    static let DRIVER_REGISTER = "driverRegisterStoryboardId"
    static let DRIVER_AUCTION = "driverAuctionStoryboardId"
    static let DRIVER_BOOKING = "driverBookingStoryboardId"
    static let DRIVER_BOOKING_INFO = "driverBookingInfoStoryboardId"
    static let DRIVER_BOOKING_MAP = "driverBookingMapStoryboardId"
    static let DRIVER_GET_BOOKING_INFO = "driverGetBookingInfoStoryboardId"
    static let DRIVER_GET_BOOKING_MAP = "driverGetBookingMapStoryboardId"
}

struct CELL_ID {
    static let PASSSENGER_TICKET = "passengerTicketCellId"
    static let DRIVER_AUCTION = "driverAuctionCellId"
    static let DRIVER_AUCTION_SUCCESS = "driverAuctionSuccessCellId"
    static let DRIVER_BOOKING = "driverBookingCellId"
}

struct DEVICE_OS {
    static let iOS = "2"
}

struct GOOGLE_API {
    static let KEY = "AIzaSyA5bQi1YZhMGVcN1MVdqcF71jUu0aq01iw"
    static let NORTH_EAST = CLLocationCoordinate2D.init(latitude: 23.393395, longitude: 109.468975)
    static let SOUTH_WEST = CLLocationCoordinate2D.init(latitude: 8.412730, longitude: 102.144410)
    static let DEFAULT_COORDINATE = CLLocationCoordinate2D.init(latitude: 20.982879, longitude: 105.925522)
    static let URL_GET_DERECTION = "https://maps.googleapis.com/maps/api/directions/json"

}

enum TYPE_VIEW {
    case PASSENGER_BOOKING, PASSENGER_GET_BOOKING, DRIVER_BOOKING, DRIVER_GET_BOOKING
}

struct STYLE_FORMAT {
    static let TEXT_FIELD_HEIGHT = 55
    static let TEXT_FIELD_BORDER_COLOR = UIColor.init(colorLiteralRed: 22/255.0, green: 189/255.0, blue: 12/255.0, alpha: 1.0)
}

let components = Calendar.current.dateComponents([.year], from: Date())
let CURRENT_YEAR = components.year

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

struct STATIC_DATA {
    static var CAR_HIRE_TYPE: NSArray = []
    static var CAR_SIZE: NSArray = []
    static var CAR_TYPE: NSArray = []
    static var CAR_MADE: NSArray = []
    static var WHO_HIRE: NSArray = []
    static var AIRPORT: NSArray = []
    static var NOTICE: NSArray = []
    static let CAR_YEAR: Array = Array(Int(CURRENT_YEAR!-20)...CURRENT_YEAR!).map{
        String($0)
    }.reversed()
    static var DRIVER_INFO: Dictionary<String, Any?> = [:]
}

struct DRIVER_STATUS {
    static var ONLINE = "0"
    static var OFFLINE = "1"
}

struct NOTIFICATION_STRING {
    static let PASSENGER_BOOKING_DONE = "notificationPassengerBookingDone"
    static let BOOKING_UPDATE_COORDINATE = "notificationBookingUpdateCoordinate"
    static let DRIVER_BOOKING_DONE = "notificationDriverBookingDone"
}

struct CONFIG_DATA {
    static let PASSWORD_MIN_LENGTH = 4
    static let LIMIT_PRICE_CHANGE_TIME_AUCTION = 1000000
    static let TIME_SCHEDULE_POST_DRIVER_LOCATION = TimeInterval(300) //5 minutes = 5*60 seconds
}
