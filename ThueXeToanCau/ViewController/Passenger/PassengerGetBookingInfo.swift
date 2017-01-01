//
//  PassengerGetBookingInfo.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/19/16.
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
import SwiftLocation

class PassengerGetBookingInfo: UIViewController, UITableViewDelegate, UITableViewDataSource, PassengerTicketDelegate {

    @IBOutlet weak var tableView: UITableView!

    var tickets = [PassengerTicket]()
    var currentLocation: CLLocationCoordinate2D?

    var name: String?
    var phone: String?
    var firstLoading: Bool = true

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
                    print(ticketsResponse)
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

        Location.getLocation(withAccuracy: .city, onSuccess: {foundLocation in
            self.updateLocation(coordinate: foundLocation.coordinate)
        }, onError: { error in
            print(error)
            Location.getLocation(withAccuracy: .ipScan, onSuccess: {ipLocation in
                self.updateLocation(coordinate: ipLocation.coordinate)
            }, onError: {error in
                print(error)
            }).start()
        }).start()

    }

    func updateLocation(coordinate: CLLocationCoordinate2D) {
        self.currentLocation = coordinate

        if firstLoading {
            firstLoading = false
            self.tableView.es_startPullToRefresh()
        }

        if self.tableView.expried {
            self.tableView.es_startPullToRefresh()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID.PASSSENGER_TICKET, for: indexPath) as? PassengerTicketCell {
            cell.updateUI(passengerTicket: tickets[indexPath.row])
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }

    func passengerBooking(bookingId: String) {
        KRProgressHUD.show(progressHUDStyle: .whiteColor, maskType: .white, activityIndicatorStyle: .black, font: nil, message: "Đang đặt vé")

        Alamofire.request(URL_APP_API.BOOKING_LOG, method: HTTPMethod.post, parameters: ["id_booking" : bookingId, "name" : self.name!, "phone" : self.phone!], encoding: JSONEncoding.default, headers: nil).responseString { response in

            if response.result.isSuccess && response.result.value == "1"{
                KRProgressHUD.showSuccess(progressHUDStyle: .whiteColor, maskType: .white, message: "Xong")
            }
            else {
                KRProgressHUD.showError(message: "Lỗi")
            }

        }
    }
}
