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

class PassengerGetBookingInfo: UIViewController, UITableViewDelegate, UITableViewDataSource, PassengerTicketDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var filterButton: UIButton!

    var tickets = [PassengerTicket]()
    var currentLocation: CLLocationCoordinate2D?

    var name: String?
    var phone: String?
    var firstLoading: Bool = true
    var searchFromString: String?
    var searchToString: String?
    var lastContentOffsetY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefault = UserDefaults.standard
        name = userDefault.string(forKey: PASSENGER_INFO.NAME)
        phone = userDefault.string(forKey: PASSENGER_INFO.PHONE)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.expriedTimeInterval = 10.0

        searchFromString = ""
        searchToString = ""

        let _ = tableView.es_addPullToRefresh() { [weak self] in
            let params:Dictionary<String, String> = ["lon" : String.init(format: "%.6f",(self?.currentLocation?.longitude)!), "lat" : String.init(format: "%.6f",(self?.currentLocation?.latitude)!),"car_hire_type" : "Chiều về,Đi chung", "order" : "1", "car_from" : self!.searchFromString!, "car_to" : self!.searchToString!]

            AlamofireManager.sharedInstance.manager.request(URL_APP_API.GET_BOOKING_CUSTOMER, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in

                if let ticketsResponse = JSON(response.result.value!).array {
                    self?.tickets.removeAll()
                    for ticket in ticketsResponse {
                        let ticket = PassengerTicket(withJSON: ticket)
                        self?.tickets.append(ticket)
                    }
                    self?.tableView.reloadData()
                    self?.tableView.es_stopPullToRefresh()
                }
            }
        }
        currentLocation = CLLocationCoordinate2D.init()
        
        Location.getLocation(accuracy: .city, frequency: .continuous, success: { foundLocation in
            self.updateLocation(coordinate: foundLocation.1.coordinate)
        }, error: { error in
            print(error)
            Location.getLocation(accuracy: .IPScan(IPService(.freeGeoIP)), frequency: .oneShot, success: { ipLocation in
                self.updateLocation(coordinate: ipLocation.1.coordinate)
            }, error: { error in
                print(error)
            }).resume()
        }).resume()
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

        AlamofireManager.sharedInstance.manager.request(URL_APP_API.BOOKING_LOG, method: HTTPMethod.post, parameters: ["id_booking" : bookingId, "name" : self.name!, "phone" : self.phone!], encoding: JSONEncoding.default, headers: nil).responseString { response in

            if response.result.isSuccess && response.result.value == "1"{
                KRProgressHUD.showSuccess(progressHUDStyle: .whiteColor, maskType: .white, message: "Xong")
            }
            else {
                KRProgressHUD.showError(message: "Lỗi")
            }

        }
    }
    
    @IBAction func filterButtonTouched(_ sender: Any) {

        let appearance = SCLAlertView.SCLAppearance(
            kTextFieldHeight: 50,
            kButtonHeight: 50,
            kTextFont: UIFont(name: "HelveticaNeue", size: 17)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 17)!,
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        let carFrom = alert.addTextField("Điểm đi")
        let carTo = alert.addTextField("Điểm đến")

        carFrom.clearButtonMode = UITextFieldViewMode.whileEditing
        carTo.clearButtonMode = UITextFieldViewMode.whileEditing
        carFrom.text = self.searchFromString
        carTo.text = self.searchToString

        _ = alert.addButton("Tìm kiếm") {
            alert.hideView()
            self.searchFromString = carFrom.text
            self.searchToString = carTo.text
            self.tableView.es_startPullToRefresh()
        }
        _ = alert.addButton("Huỷ") {
            alert.hideView()
        }
        alert.showEdit("Tìm kiếm", subTitle: "Nhập địa điểm bạn muốn tìm")
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if lastContentOffsetY < scrollView.contentOffset.y {
            UIView.animate(withDuration: 0.3, animations: {
                self.filterButton.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT-114, width: SCREEN_WIDTH, height: 0)
            }, completion: { complete in
                self.filterButton.isHidden = true
            })
        }
        else {
            self.filterButton.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.filterButton.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT-158, width: SCREEN_WIDTH, height: 44)
            })
        }
    }

}
