//
//  PassengerBookingMap.swift
//  ThueXeToanCau
//
//  Created by VMio69 on 12/18/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import RxSwift
import GoogleMaps
import Alamofire
import SwiftyJSON

class PassengerBookingMap: UIViewController {

    var fromCoordinate: CLLocationCoordinate2D? = GOOGLE_API.DEFAULT_COORDINATE
    var toCoordinate: CLLocationCoordinate2D? = GOOGLE_API.DEFAULT_COORDINATE
    var fromMaker: GMSMarker?
    var toMaker: GMSMarker?
    var mapView: GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let camera = GMSCameraPosition.camera(withTarget: GOOGLE_API.DEFAULT_COORDINATE, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView

        // Creates a marker in the center of the map.
        fromMaker = GMSMarker.init(position: GOOGLE_API.DEFAULT_COORDINATE)
        toMaker = GMSMarker.init(position: GOOGLE_API.DEFAULT_COORDINATE)


        NotificationCenter.default.addObserver(self, selector: #selector(updateCoordinate), name: NSNotification.Name(NOTIFICATION_STRING.BOOKING_UPDATE_COORDINATE), object: nil)
    }

    func updateCoordinate(noti: Notification) {

        if let from:CLLocationCoordinate2D = (noti.object as! Dictionary)["fromCoordinate"] {
            fromCoordinate = from

        }
        if let to:CLLocationCoordinate2D = (noti.object as! Dictionary)["toCoordinate"] {
            toCoordinate = to

        }
        if (fromCoordinate?.notEqual(GOOGLE_API.DEFAULT_COORDINATE))! && (toCoordinate?.notEqual(GOOGLE_API.DEFAULT_COORDINATE))! {
            Alamofire.request(GOOGLE_API.URL_GET_DERECTION + "?origin=\((fromCoordinate?.latitude)!),\((fromCoordinate?.longitude)!)&destination=\((toCoordinate?.latitude)!),\((toCoordinate?.longitude)!)&sensor=true" , method: HTTPMethod.post, parameters: [:], encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    if json["status"] == "OK" {
                        self.fromMaker?.map = nil
                        self.toMaker?.map = nil
                        self.mapView?.clear()

                        self.fromMaker = GMSMarker.init(position: self.fromCoordinate!)
                        self.toMaker = GMSMarker.init(position: self.toCoordinate!)
                        self.fromMaker?.title = "Điểm đi"
                        self.fromMaker?.icon = GMSMarker.markerImage(with: UIColor.green)
                        self.toMaker?.title = "Điểm đến"
                        self.toMaker?.icon = GMSMarker.markerImage(with: UIColor.red)
                        self.fromMaker?.position = self.fromCoordinate!
                        self.fromMaker?.map = self.mapView
                        self.toMaker?.position = self.toCoordinate!
                        self.toMaker?.map = self.mapView

                        let path = GMSPath.init(fromEncodedPath: json["routes"][0]["overview_polyline"]["points"].string!)
                        let singleLine = GMSPolyline.init(path: path)
                        singleLine.strokeWidth = 7
                        singleLine.strokeColor = UIColor.init(red: 0/255.0, green: 186/255.0, blue: 250/255.0, alpha: 1.0)
                        singleLine.map = self.mapView

                        let bounds = GMSCoordinateBounds(coordinate: self.fromCoordinate!, coordinate: self.toCoordinate!)
                        let camera = self.mapView?.camera(for: bounds, insets: UIEdgeInsets())
                        self.mapView?.camera = camera!
                        let zoomCamera = GMSCameraUpdate.zoomOut()
                        self.mapView?.animate(with: zoomCamera)
                    }
                }
                
            }
        }
    }
}

extension CLLocationCoordinate2D {
    func notEqual(_ other: CLLocationCoordinate2D) -> Bool {
        return self.latitude != other.latitude || self.longitude != other.longitude
    }
}
