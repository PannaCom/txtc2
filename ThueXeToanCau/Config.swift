//
//  Config.swift
//  ThueXeToanCau
//
//  Created by VMio69 on 12/17/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

// API
let HOSTNAME = "http://thuexetoancau.vn/"
struct URL_APP_API {
   static let GET_CAR_HIRE_TYPE = HOSTNAME + "api/getCarHireType"
   static let GET_CAR_TYPE = HOSTNAME + "api/getCarSize"
//   static let GET_CAR_TYPE = HOSTNAME + "api/getListCarType"
//   static let GET_CAR_MADE = HOSTNAME + "api/getCarMadeList"
//   static let GET_CAR_MODEL = HOSTNAME + "api/getCarModelListFromMade"
   static let GET_WHO_HIRE = HOSTNAME + "api/getCarWhoHire"

   static let BOOKING_TICKET  = HOSTNAME + "api/booking"
   static let GET__BOOKING = HOSTNAME + "api/getBooking"
   static let BOOKING_FINAL = HOSTNAME + "api/bookingFinal"

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
}


struct PASSENGER_INFO{
    static let NAME = "namePassenger"
    static let PHONE = "phonePassenger"
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
    static let DRIVER_AUCTION = "driverAuctionSegueId"
}

struct STORYBOARD_ID {
    static let PASSENGER_SELECT_ACTIVITY = "passengerSelectActivityStoryboardId"
    static let DRIVER_AUCTION = "driverAuctionStoryboardId"

    static let PASSENGER_BOOKING_INFO = "passengerBookingInfoStoryboardId"
    static let PASSENGER_BOOKING_MAP = "passengerBookingMapStoryboardId"
    static let PASSENGER_GET_BOOKING_INFO = "passengerGetBookingInfoStoryboardId"
    static let PASSENGER_GET_BOOKING_MAP = "passengerGetBookingMapStoryboardId"

    static let DRIVER_BOOKING_INFO = "driverBookingInfoStoryboardId"
    static let DRIVER_BOOKING_MAP = "driverBookingMapStoryboardId"
    static let DRIVER_GET_BOOKING_INFO = "driverGetBookingInfoStoryboardId"
    static let DRIVER_GET_BOOKING_MAP = "driverGetBookingMapStoryboardId"
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

struct STATIC_DATA {
    static var CAR_HIRE_TYPE: NSArray = []
    static var CAR_TYPE: NSArray = []
    static var WHO_HIRE: NSArray = []
    static var AIRPORT: NSArray = []
    static var NOTICE: NSArray = []
}

struct NOTIFICATION_STRING {
    static let PASSENGER_BOOKING_DONE = "notificationPassengerBookingDone"
    static let BOOKING_UPDATE_COORDINATE = "notificationBookingUpdateCoordinate"
}
