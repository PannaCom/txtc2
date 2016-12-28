//
//  CustomExtension.swift
//  ThueXeToanCau
//
//  Created by VMio69 on 12/28/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import Foundation

extension String {
    func customNumberStyle() -> String {
        let currencyFormat = NumberFormatter()
        currencyFormat.numberStyle = .decimal
        currencyFormat.groupingSize = 3
        currencyFormat.maximumFractionDigits = 0

        return currencyFormat.string(from: NSNumber.init(value: Int(self)!))!
    }

    func serverDateTimeToFormatddMMhhmm() -> String {
        let serverFormat = DateFormatter()
        serverFormat.dateFormat = "yyyy-MM-ddHH:mm:ss"
        let date = serverFormat.date(from: self.replacingOccurrences(of: "T", with: ""))
        let customFormat = DateFormatter()
        customFormat.dateFormat = "dd/MM hh:mm"

        return customFormat.string(from: date!)
    }
}
