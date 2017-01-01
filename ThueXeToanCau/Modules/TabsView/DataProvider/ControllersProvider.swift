//
//  ControllersProvider.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/19/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import ColorMatchTabs

class TabsContentViewControllersProvider {

    static let viewControllersPassengerBooking: [UIViewController] = {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let infoViewController = mainStoryboard.instantiateViewController(withIdentifier: STORYBOARD_ID.PASSENGER_BOOKING_INFO)

        let mapViewController = mainStoryboard.instantiateViewController(withIdentifier: STORYBOARD_ID.PASSENGER_BOOKING_MAP)

        return [infoViewController, mapViewController]
    }()

    static let viewControllersPassengerGetBooking: [UIViewController] = {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)

        let infoViewController = mainStoryboard.instantiateViewController(withIdentifier: STORYBOARD_ID.PASSENGER_GET_BOOKING_INFO)

        let mapViewController = mainStoryboard.instantiateViewController(withIdentifier: STORYBOARD_ID.PASSENGER_GET_BOOKING_MAP)

        return [infoViewController, mapViewController]
    }()

    static let viewControllersDriverBooking: [UIViewController] = {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)

        let infoViewController = mainStoryboard.instantiateViewController(withIdentifier: STORYBOARD_ID.DRIVER_BOOKING_INFO)

        let mapViewController = mainStoryboard.instantiateViewController(withIdentifier: STORYBOARD_ID.PASSENGER_BOOKING_MAP)

        return [infoViewController, mapViewController]
    }()

    static let viewControllersDriverGetBooking: [UIViewController] = {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)

        let infoViewController = mainStoryboard.instantiateViewController(withIdentifier: STORYBOARD_ID.PASSENGER_BOOKING_INFO)

        let mapViewController = mainStoryboard.instantiateViewController(withIdentifier: STORYBOARD_ID.PASSENGER_BOOKING_MAP)

        return [infoViewController, mapViewController]
    }()

}
