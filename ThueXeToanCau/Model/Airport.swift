//
//  Airport.swift
//  ThueXeToanCau
//
//  Created by VMio69 on 12/23/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import Foundation
import UIKit

class Airport: NSObject {
//    private let id: String
     let airportName: String
//    private let carFrom: String
//    private let carTo: String
     let lon1: String
     let lat1: String
     let lon2: String
     let lat2: String

    init(airportName: String, lon1: String, lat1: String, lon2: String, lat2: String) {
        self.airportName = airportName
        self.lon1 = lon1
        self.lat1 = lat1
        self.lon2 = lon2
        self.lat2 = lat2
        
        super.init()
    }
}
