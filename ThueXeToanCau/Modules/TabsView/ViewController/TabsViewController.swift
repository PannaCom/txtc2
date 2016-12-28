//
//  ExampleViewController.swift
//  ThueXeToanCau
//
//  Created by VMio69 on 12/19/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//


import Foundation
import UIKit
import RxSwift
import ColorMatchTabs

class TabsViewController: ColorMatchTabsViewController {

    let disposeBag = DisposeBag()

    var typeView: TYPE_VIEW!

    init(typeView: TYPE_VIEW) {
        self.typeView = typeView

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        reloadData()

    }
}

extension TabsViewController: ColorMatchTabsViewControllerDataSource {

    func numberOfItems(inController controller: ColorMatchTabsViewController) -> Int {

        if typeView == TYPE_VIEW.DRIVER_BOOKING || typeView == TYPE_VIEW.PASSENGER_BOOKING {
            return TabItemsProvider.itemsForBooking.count
        }

        if typeView == TYPE_VIEW.DRIVER_GET_BOOKING || typeView == TYPE_VIEW.PASSENGER_GET_BOOKING {
            return TabItemsProvider.itemsForGetBooking.count
        }

        return 1
    }

    func tabsViewController(_ controller: ColorMatchTabsViewController, viewControllerAt index: Int) -> UIViewController {

        switch typeView! {
        case .DRIVER_BOOKING:
            return TabsContentViewControllersProvider.viewControllersDriverBooking[index]
        case .DRIVER_GET_BOOKING:
            return TabsContentViewControllersProvider.viewControllersDriverGetBooking[index]
        case .PASSENGER_BOOKING:
            return TabsContentViewControllersProvider.viewControllersPassengerBooking[index]
        case .PASSENGER_GET_BOOKING:
            return TabsContentViewControllersProvider.viewControllersPassengerGetBooking[index]
//        default:

        }
    }

    func tabsViewController(_ controller: ColorMatchTabsViewController, titleAt index: Int) -> String {
        if typeView == TYPE_VIEW.DRIVER_BOOKING || typeView == TYPE_VIEW.PASSENGER_BOOKING {
            return TabItemsProvider.itemsForBooking[index].title
        }

        if typeView == TYPE_VIEW.DRIVER_GET_BOOKING || typeView == TYPE_VIEW.PASSENGER_GET_BOOKING {
            return TabItemsProvider.itemsForGetBooking[index].title
        }

        return TabItemsProvider.itemsForBooking[index].title
    }

    func tabsViewController(_ controller: ColorMatchTabsViewController, iconAt index: Int) -> UIImage {
        if typeView == TYPE_VIEW.DRIVER_BOOKING || typeView == TYPE_VIEW.PASSENGER_BOOKING {
            return TabItemsProvider.itemsForBooking[index].normalImage
        }

        if typeView == TYPE_VIEW.DRIVER_GET_BOOKING || typeView == TYPE_VIEW.PASSENGER_GET_BOOKING {
            return TabItemsProvider.itemsForGetBooking[index].normalImage
        }
        return TabItemsProvider.itemsForBooking[index].normalImage
    }

    func tabsViewController(_ controller: ColorMatchTabsViewController, hightlightedIconAt index: Int) -> UIImage {
        if typeView == TYPE_VIEW.DRIVER_BOOKING || typeView == TYPE_VIEW.PASSENGER_BOOKING {
            return  TabItemsProvider.itemsForBooking[index].highlightedImage
        }

        if typeView == TYPE_VIEW.DRIVER_GET_BOOKING || typeView == TYPE_VIEW.PASSENGER_GET_BOOKING {
            return  TabItemsProvider.itemsForGetBooking[index].highlightedImage
        }
        return TabItemsProvider.itemsForBooking[index].highlightedImage
    }

    func tabsViewController(_ controller: ColorMatchTabsViewController, tintColorAt index: Int) -> UIColor {
        if typeView == TYPE_VIEW.DRIVER_BOOKING || typeView == TYPE_VIEW.PASSENGER_BOOKING {
            return  TabItemsProvider.itemsForBooking[index].tintColor
        }

        if typeView == TYPE_VIEW.DRIVER_GET_BOOKING || typeView == TYPE_VIEW.PASSENGER_GET_BOOKING {
            return  TabItemsProvider.itemsForGetBooking[index].tintColor
        }
        return TabItemsProvider.itemsForBooking[index].tintColor
    }
    
}
