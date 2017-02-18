//
//  PassengerGetBookingMap.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/19/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import RxSwift
import GoogleMaps
import Alamofire
import SwiftyJSON
import SwiftLocation

class PassengerGetBookingMap: UIViewController {
    var mapView: GMSMapView?
    var getAroundTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withTarget: GOOGLE_API.DEFAULT_COORDINATE, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCurrentLocation()
        getAroundTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(updateCurrentLocation), userInfo: nil, repeats: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getAroundTimer?.invalidate()
        getAroundTimer = nil
    }

    func getAround(coordinate: CLLocationCoordinate2D) {
        let params = ["lon" : String.init(format: "%.6f", (coordinate.longitude)), "lat" : String.init(format: "%.6f", (coordinate.latitude))]
        AlamofireManager.sharedInstance.manager.request(URL_APP_API.PASSENGER_GET_AROUND, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {
            response in
            if response.result.isSuccess {
                self.mapView?.clear()
//                print(response.result.value!)
                let maker = GMSMarker.init(position: coordinate)
                maker.map = self.mapView

                var r:Float = 0

                if let carArounds = JSON(response.result.value!).array {
                    for car in carArounds {
                        let lon = car["lon"]
                        let lat = car["lat"]
                        let makerCar = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: lat.double!, longitude: lon.double!))
                        makerCar.map = self.mapView
                        let d = Float.init( String(describing: car["D"]))
                        r = Float.maximum(r, 1000*d!)
                        makerCar.title = "cách " + (d! < Float.init(1.0) ? (String.init(format: "%d", 1000*d!) + " m") : (String.init(format: "%.3f",d!) + " km"))
                    }
                    if r > 0 {
                        let circle = GMSCircle()
                        circle.radius = CLLocationDistance(r)
                        circle.fillColor = UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.1)
                        circle.position = coordinate
                        circle.strokeWidth = 3
                        circle.strokeColor = UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.7)
                        circle.map = self.mapView

                    }
                }
            }
        })
    }

    func updateCurrentLocation() {
        Location.getLocation(withAccuracy: .navigation, onSuccess: {
            location in
            self.getAround(coordinate: location.coordinate)
        }, onError: {
            error in
            Location.getLocation(withAccuracy: .ipScan, frequency: .oneShot, timeout: 30, onSuccess: { ipLocation in
                 self.getAround(coordinate: ipLocation.coordinate)
            }, onError: {
                error in
                print(error)
            }).start()
        }).start()
    }

}
