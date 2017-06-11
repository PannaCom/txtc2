//
//  CustomExtension.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/28/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import Foundation
import SwiftMessages

extension String {
    func customNumberStyle() -> String {
        let currencyFormat = NumberFormatter()
        currencyFormat.numberStyle = .decimal
        currencyFormat.groupingSize = 3
        currencyFormat.maximumFractionDigits = 0

        return currencyFormat.string(from: NSNumber.init(value: Int(self)!))!
    }

    func serverDateTimeTo(format: String) -> String {
        let serverFormat = DateFormatter()
        if self.characters.count > 20 {
            serverFormat.dateFormat = "yyyy-MM-ddHH:mm:ss.SSS"
        }
        else {
            serverFormat.dateFormat = "yyyy-MM-ddHH:mm:ss"
        }

        let date = serverFormat.date(from: self.replacingOccurrences(of: "T", with: ""))
        let customFormat = DateFormatter()
        customFormat.dateFormat = format

        return customFormat.string(from: date!)
    }

    func serverDateTimeToDate() -> Date {
        let serverFormat = DateFormatter()
        serverFormat.dateFormat = "yyyy-MM-ddHH:mm:ss"
        var str: String

        if self.characters.count > 19 {
            str = self.substring(to: self.index(self.startIndex, offsetBy: 19))
        }
        else {
            str = self
        }
        let secondsFromGMT = TimeZone.current.secondsFromGMT()
        return serverFormat.date(from: str.replacingOccurrences(of: "T", with: ""))!.addingTimeInterval(TimeInterval(secondsFromGMT))
    }
}

extension SwiftMessages {
    public static func show(title: String, message: String, layout: MessageView.Layout, theme: Theme) {
        SwiftMessages.show {
            let view = MessageView.viewFromNib(layout: layout)
            view.configureContent(title: title, body: message)
            view.configureTheme(theme)
            return view
        }
    }
}

extension Date {
    public static func current() -> Date {
        let secondsFromGMT = TimeZone.current.secondsFromGMT()

        return Date().addingTimeInterval(TimeInterval(secondsFromGMT))
    }
}
