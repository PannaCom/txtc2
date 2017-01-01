//
//  DriverAuction.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/17/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import RxCocoa
import SwiftLocation
import SwiftMessages
import CoreLocation
import ESPullToRefresh
import Alamofire
import SCLAlertView
import DropDown

class DriverAuction: UIViewController, UITableViewDataSource, UITableViewDelegate, DriverAuctionDelegate, UIScrollViewDelegate {

    @IBOutlet var backButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    
    @IBOutlet var tableView: UITableView!

    var tickets = [PassengerTicket]()
    var currentLocation: CLLocationCoordinate2D?
    var firstLoading: Bool = true
    let disposeBag = DisposeBag()
    var canAuction: Bool?
    var menuDropDown = DropDown()

    @IBOutlet var moneyLabel: UILabel!
    @IBOutlet var moneyView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.rx.tap
            .subscribe(onNext: {self .dismiss(animated: true, completion: nil)})
            .addDisposableTo(disposeBag)
        menuButton.rx.tap
            .subscribe(onNext: {
                self.menuDropDown.show()
            })
            .addDisposableTo(disposeBag)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.expriedTimeInterval = 10.0

        let _ = tableView.es_addPullToRefresh { [weak self] in
            let params:Dictionary<String, String> = ["lon" : String.init(format: "%.6f", (self?.currentLocation?.longitude)!), "lat" : String.init(format: "%.6f", (self?.currentLocation?.latitude)!), "order" : "1", "car_hire_type" : "Một chiều,Khứ hồi,Sân bay"]
            Alamofire.request(URL_APP_API.GET_BOOKING_CUSTOMER, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {response in
                if let ticketResponse = JSON(response.result.value!).array {
//                    print(ticketResponse)
                    for ticket in ticketResponse {
                        let ticket = PassengerTicket.init(withJSON: ticket)
                        self?.tickets.append(ticket)
                    }
                    self?.tableView.reloadData()
                    self?.tableView.es_stopPullToRefresh()
                }
                })
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

        menuDropDown.anchorView = menuButton
        menuDropDown.dataSource = ["Đăng chuyến chiều về, đi chung", "Chuyến đấu giá thành công", "Danh sách chuyến đã đăng"/*, "Sửa thông tin"*/]
        menuDropDown.bottomOffset = CGPoint(x: menuButton.bounds.width-menuDropDown.bounds.width, y: menuButton.bounds.height)
        menuDropDown.selectionBackgroundColor = UIColor.yellow
        menuDropDown.selectionAction = { [unowned self] (index, item) in
            switch index {
            case 0:
                let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "driverBookingStoryboardId")
                self.present(vc, animated: true, completion: nil)
            case 2:
                self.performSegue(withIdentifier: "auctionToDriverBookingsSegueId", sender: self)
            case 1:
                print(item)
                self.performSegue(withIdentifier: "auctionToSuccessSegueId", sender: self)
            default:
                print(item)
            }
        }
        getMoneyDriver()
//        moneyLabel.text = "\(STATIC_DATA.DRIVER_INFO[DRIVER_INFO.TOTAL_MONEY]!)".customNumberStyle() + " đồng"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        canAuction = String(describing: (STATIC_DATA.DRIVER_INFO[DRIVER_INFO.STATUS]!)!) == "0" ? true : false
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID.DRIVER_AUCTION, for: indexPath) as? DriverAuctionCell{
            cell.updateUI(ticket: tickets[indexPath.row])
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

    func auctionButtonTouched(bookingId: String, priceBuy: String, priceMax: String) {
        if bookingId == "-1" {
            SwiftMessages.show(title: "Lỗi", message: "Đã hết thời gian đấu giá!", layout: .MessageViewIOS8, theme: .error)
        }
        else {
            if canAuction! {
                print("auction")
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alert = SCLAlertView(appearance: appearance)
                let priceTextField = alert.addTextField("Nhập giá đấu")
                priceTextField.keyboardType = .numberPad
                _ = alert.addButton("Xong", backgroundColor: UIColor.green, textColor: UIColor.white, showDurationStatus: true, action: {
                    if Int(priceBuy)! > Int(priceTextField.text!)! || Int(priceMax)! < Int(priceTextField.text!)! {
                        SwiftMessages.show(title:"Lỗi:", message: "Giá đấu phải nằm trong khoảng \(priceBuy.customNumberStyle()) - \(priceMax.customNumberStyle())", layout: .MessageViewIOS8, theme: .error)
                    }
                    else {
                        self.auction(bookingId: bookingId, priceAuction: priceTextField.text!, type: "0")
                    }
                    alert.dismiss(animated: true, completion: nil)
                })
                _ = alert.addButton("Hủy", backgroundColor: UIColor.darkGray, textColor: UIColor.white, showDurationStatus: true, action: {
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.showEdit("Đấu giá", subTitle: "Khoảng giá: \(priceBuy.customNumberStyle()) đ - \(priceMax.customNumberStyle()) đ")

            }
            else {
                SwiftMessages.show(title: "Lỗi", message: "Tài khoản này không thể đấu giá!", layout: .MessageViewIOS8, theme: .error)
            }

        }

    }

    func buyNowButtonTouched(bookingId: String, priceBuy: String) {
        if bookingId == "-1" {
            SwiftMessages.show(title: "Lỗi", message: "Đã hết thời gian đấu giá!", layout: .MessageViewIOS8, theme: .error)
            print(priceBuy)
        }
        else {
            if canAuction! {
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alert = SCLAlertView(appearance: appearance)
                _ = alert.addButton("Đồng ý", backgroundColor: UIColor.green, textColor: UIColor.white, showDurationStatus: true, action: {
                    self.auction(bookingId: bookingId, priceAuction: priceBuy, type: "1")
                    alert.dismiss(animated: true, completion: nil)
                })
                _ = alert.addButton("Hủy", backgroundColor: UIColor.darkGray, textColor: UIColor.white, showDurationStatus: true, action: {
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.showEdit("Mua ngay", subTitle: "Bạn muốn mua ngay với giá: \(priceBuy.customNumberStyle())?")

            }
            else {
                SwiftMessages.show(title: "Lỗi", message: "Tài khoản này không thể đấu giá!", layout: .MessageViewIOS8, theme: .error)
            }

        }
    }
    func auction(bookingId: String, priceAuction: String, type: String) {
        Alamofire.request(URL_APP_API.BOOKING_FINAL, method: HTTPMethod.post, parameters: ["id_booking" : bookingId, "id_driver" : STATIC_DATA.DRIVER_INFO[DRIVER_INFO.ID]!!, "driver_number" : STATIC_DATA.DRIVER_INFO[DRIVER_INFO.CAR_NUMBER]!!, "driver_phone" : STATIC_DATA.DRIVER_INFO[DRIVER_INFO.PHONE]!!, "price" : priceAuction, "type" : type], encoding: JSONEncoding.default, headers: nil).responseString(completionHandler: { response in
            switch response.result.value! {
                case "1":
                    print("thành công")
                    SwiftMessages.show(title: "Đấu giá thành công", message: "Hãy chờ kết quả đấu giá", layout: .MessageViewIOS8, theme: .success)
                    self.getMoneyDriver()
                case "0":
                    print("đã có người mua")
                    SwiftMessages.show(title: "Đấu giá thất bại", message: "Đã có người mua trước", layout: .MessageViewIOS8, theme: .error)
                case "-1":
                    print("Lỗi mạng")
                    SwiftMessages.show(title: "Lỗi mạng", message: "", layout: .MessageViewIOS8, theme: .error)
            default:
                break

            }
        })
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        if scrollView == self.tableView {
            if scrollView.contentOffset.y > scrollView.contentSize.height - 3*self.tableView.rowHeight {
                moneyView.isHidden = true
            }
            else {
                moneyView.isHidden = false
            }
        }
    }
    func getMoneyDriver() {
        Alamofire.request(URL_APP_API.GET_MONEY_DRIVER, method: HTTPMethod.post, parameters: ["id_driver" : STATIC_DATA.DRIVER_INFO[DRIVER_INFO.ID]!!], encoding: JSONEncoding.default, headers: nil).responseString(completionHandler: {response in
            self.moneyLabel.text = response.result.value!.customNumberStyle() + " đồng"
        })
    }
}

