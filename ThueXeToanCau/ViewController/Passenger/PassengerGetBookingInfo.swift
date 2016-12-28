//
//  PassengerGetBookingInfo.swift
//  ThueXeToanCau
//
//  Created by VMio69 on 12/19/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import RxSwift
import ESPullToRefresh
import Alamofire
import CoreLocation
import SwiftyJSON
import SCLAlertView
import KRProgressHUD

class PassengerGetBookingInfo: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, PassengerTicketDelegate {

    @IBOutlet weak var tableView: UITableView!

    var tickets = [PassengerTicket]()
    var currentLocation: CLLocationCoordinate2D?
    var locationManager: CLLocationManager?

    var name: String?
    var phone: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefault = UserDefaults.standard
        name = userDefault.string(forKey: PASSENGER_INFO.NAME)
        phone = userDefault.string(forKey: PASSENGER_INFO.PHONE)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.expriedTimeInterval = 10.0

        let _ = tableView.es_addPullToRefresh() { [weak self] in
            let params:Dictionary<String, String> = ["lon" : String.init(format: "%.6f",(self?.currentLocation?.longitude)!), "lat" : String.init(format: "%.6f",(self?.currentLocation?.latitude)!),"car_hire_type" : "Chiều về,Đi chung", "order" : "1"]

            Alamofire.request(URL_APP_API.GET_BOOKING_CUSTOMER, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                if let ticketsResponse = JSON(response.result.value!).array {
                    for ticket in ticketsResponse {
                        let ticket = PassengerTicket.init(withJSON: ticket)
                        self?.tickets.append(ticket)
                    }
                    self?.tableView.reloadData()
                    self?.tableView.es_stopPullToRefresh()
                }
            }

        }

        currentLocation = CLLocationCoordinate2D.init()

        locationManager = CLLocationManager.init()
        locationManager?.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.distanceFilter = kCLDistanceFilterNone
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest

            locationManager?.startUpdatingLocation()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "passengerTicketCellId", for: indexPath) as? PassengerTicketCell {
            let ticket = tickets[indexPath.row]
            cell.updateUI(passengerTicket: ticket)
            cell.delegate = self
            return cell
        }
        else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first?.coordinate
        if tableView.expried {
             tableView.es_startPullToRefresh()
        }

    }

    func passengerBooking(bookingId: String) {
        KRProgressHUD.showText(message: "Đang đặt vé ...")

        Alamofire.request(URL_APP_API.BOOKING_LOG, method: HTTPMethod.post, parameters: ["id_booking" : bookingId, "name" : self.name!, "phone" : self.phone!], encoding: JSONEncoding.default, headers: nil).responseString { response in
//            print(response)

            if response.result.isSuccess && response.result.value == "1"{

                KRProgressHUD.showSuccess(message: "Xong")
                let alert = SCLAlertView()
                alert.showInfo("Đặt vé thành công", subTitle: "Tài xế sẽ liên hệ với bạn để xác nhận")

            }
            else {
                KRProgressHUD.showError(message: "Lỗi")
            }

        }
    }
}
