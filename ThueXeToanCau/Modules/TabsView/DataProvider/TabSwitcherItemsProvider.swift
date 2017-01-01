//
//  TabSwitcherItemsProvider.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/19/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import ColorMatchTabs

class TabItemsProvider {

    static let itemsForBooking = {
        return [
            TabItem(
                title: "Biểu mẫu",
                tintColor: UIColor.orange,
                normalImage: UIImage(named: "edit_selected")!,
                highlightedImage: UIImage(named: "edit")!
            ),
            TabItem(
                title: "Bản đồ",
                tintColor: UIColor.orange,
                normalImage: UIImage(named: "map_selected")!,
                highlightedImage: UIImage(named: "map")!
            )
        ]
    }()

    static let itemsForGetBooking = {
        return [
            TabItem(
                title: "Danh sách",
                tintColor: UIColor.orange,
                normalImage: UIImage(named: "list_selected")!,
                highlightedImage: UIImage(named: "list")!
            ),
            TabItem(
                title: "Bản đồ",
                tintColor: UIColor.orange,
                normalImage: UIImage(named: "map_selected")!,
                highlightedImage: UIImage(named: "map")!
            )
        ]
    }()
    
}
