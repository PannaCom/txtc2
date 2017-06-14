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
import UserNotifications

class DriverAuction: UIViewController, UITableViewDataSource, UITableViewDelegate, DriverAuctionDelegate, UIScrollViewDelegate {

    @IBOutlet var backButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var moneyLabel: UILabel!
    @IBOutlet var moneyView: UIView!
    @IBOutlet var changeStatusButton: UIButton!
    @IBOutlet var bookingThuaKhachButton: UIButton!
    @IBOutlet var bookingFindPassengerButton: UIButton!
    @IBOutlet var footerView: UIView!

    var tickets = [PassengerTicket]()
    var currentLocation: CLLocationCoordinate2D?
    var firstLoading: Bool = true
    let disposeBag = DisposeBag()
    var canAuction: Bool?
    var menuDropDown = DropDown()
    var subMenuDropDown = DropDown()
    var isBusy: Bool? = false
    var lastContentOffsetY: CGFloat = 0
    var timerPostDriverGPS: Timer?
    var driverStatus = DRIVER_STATUS.ONLINE

    // MARK: - View Cycle Life
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

            AlamofireManager.sharedInstance.manager.request(URL_APP_API.GET__BOOKING, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {response in
                if let ticketResponse = JSON(response.result.value!).array {
                    self?.tickets.removeAll()
                    for ticket in ticketResponse {
                        let ticket = PassengerTicket.init(withJSON: ticket)
//                        if ticket.priceBookDouble >= 1000000 {
//                            if ticket.dateFromDate > Date.init(timeInterval: -60*60*24*5, since: Date()) {
                                self?.tickets.append(ticket)
//                            }
//                        }
//                        else {
//                            if ticket.dateFromDate > Date.init(timeInterval: -60*60*24, since: Date()) {
//                                self?.tickets.append(ticket)
//                            }
//                        }
                    }
                    self?.tableView.reloadData()
                    self?.tableView.es_stopPullToRefresh()
                }
                })
            self?.getMoneyDriver()
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

        menuDropDown.anchorView = menuButton
        menuDropDown.dataSource = ["Đăng chuyến tìm khách đi chung/chiều về", "Chuyến đấu giá thành công", "Danh sách chuyến đã đăng", "Xem sao kê", "Sửa thông tin"]
        menuDropDown.bottomOffset = CGPoint(x: menuButton.bounds.width-menuDropDown.bounds.width, y: menuButton.bounds.height)
        menuDropDown.selectionBackgroundColor = UIColor.yellow
        
        subMenuDropDown.anchorView = menuButton
        subMenuDropDown.bottomOffset = CGPoint(x: menuButton.bounds.width-menuDropDown.bounds.width, y: menuButton.bounds.height)
        subMenuDropDown.dataSource = ["Sao kê Grab", "Bảng lương tài xế", "Bảng công nợ tài xế"]
        subMenuDropDown.selectionBackgroundColor = .yellow
        subMenuDropDown.selectionAction = { [unowned self] (index, item) in
            switch index {
            case 0:
                self.performSegue(withIdentifier: "driveGetTransactionSegueId", sender: self)
            case 1:
                self.performSegue(withIdentifier: "driveGetSalarySegueId", sender: self)
            case 2:
                self.performSegue(withIdentifier: "driveGetTranOwnSegueId", sender: self)
            default:
                print(item)
            }
        }
        
        
        menuDropDown.selectionAction = { [unowned self] (index, item) in
            switch index {
            case 0:
                let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: STORYBOARD_ID.DRIVER_BOOKING)
                self.present(vc, animated: true, completion: nil)
            case 1:
                print(item)
                self.performSegue(withIdentifier: "auctionToSuccessSegueId", sender: self)
            case 2:
                self.performSegue(withIdentifier: "auctionToDriverBookingsSegueId", sender: self)
            case 3:
                self.subMenuDropDown.show()
            case 4:
                let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc: DriverRegister = mainStoryboard.instantiateViewController(withIdentifier: STORYBOARD_ID.DRIVER_REGISTER) as! DriverRegister
                vc.isEditing = true
                self.present(vc, animated: true, completion: nil)
            default:
                print(item)
            }
        }

        self.updateLocationPostDriverGPS()
        timerPostDriverGPS = Timer.scheduledTimer(timeInterval: CONFIG_DATA.TIME_SCHEDULE_POST_DRIVER_LOCATION, target: self, selector: #selector(updateLocationPostDriverGPS), userInfo: nil, repeats: true)

        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotiCheckWhoWin(noti:)), name: NSNotification.Name(rawValue: "notificationCheckWhoWin"), object: nil)
    }

    func receiveNotiCheckWhoWin(noti: Notification) {
        if let info = noti.userInfo as? Dictionary<String,Any>  {
            print(info)
            SwiftMessages.show(title: "Hết thời gian đấu giá", message: info["bookingId"]! as! String, layout: .MessageViewIOS8, theme: .info)
            checkWhoWin(bookingId: info["bookingId"] as! String)
        }
        else {
            print("wrong userInfo type")
        }

//        checkWhoWin(bookingId: "")
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
    // MARK: - TableView Delegate
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

    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView {

            if (lastContentOffsetY > scrollView.contentOffset.y && scrollView.contentOffset.y < scrollView.contentSize.height - SCREEN_HEIGHT) || scrollView.contentOffset.y <= 0{
                UIView.animate(withDuration: 0.3, animations: {
                    self.footerView.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT-88, width: SCREEN_WIDTH, height: 88)
                })
            }
            else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.footerView.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 0)
                })
            }
            lastContentOffsetY = scrollView.contentOffset.y
        }
    }

    // MARK: - Events
    @IBAction func changeStatusButtonTouched(_ sender: Any) {
        if isBusy == true {
            isBusy = !isBusy!
            driverStatus = DRIVER_STATUS.ONLINE
            self.updateLocationPostDriverGPS()
            timerPostDriverGPS = Timer.scheduledTimer(timeInterval: CONFIG_DATA.TIME_SCHEDULE_POST_DRIVER_LOCATION, target: self, selector: #selector(updateLocationPostDriverGPS), userInfo: nil, repeats: true)
            changeStatusButton.setTitle("Chờ khách", for: UIControlState.normal)
            changeStatusButton.layer.backgroundColor = UIColor.init(red: 22.0/255, green: 189.0/255, blue: 12.0/255, alpha: 1.0).cgColor
        }
        else {
            isBusy = !isBusy!
            driverStatus = DRIVER_STATUS.OFFLINE
            self.updateLocationPostDriverGPS()
            timerPostDriverGPS?.invalidate()
            timerPostDriverGPS = nil
            changeStatusButton.setTitle("Bận", for: UIControlState.normal)
            changeStatusButton.layer.backgroundColor = UIColor.init(red: 254.0/255, green: 3.0/255, blue: 5.0/255, alpha: 1.0).cgColor
        }
    }

    @IBAction func bookingThuaKhachButtonTouched(_ sender: Any) {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc: PassengerLogin = mainStoryboard.instantiateViewController(withIdentifier: STORYBOARD_ID.PASSENGER_LOGIN) as! PassengerLogin
        vc.isDriver = true
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func bookingFindPassengerButtonTouched(_ sender: Any) {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: STORYBOARD_ID.DRIVER_BOOKING)
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func unwinToDriverGetBooking(segue: UIStoryboardSegue) {}

    func updateLocationPostDriverGPS() {
        Location.getLocation(accuracy: .navigation, frequency: .continuous, success: { foundLocation in
            self.postDrive(coordinate: foundLocation.1.coordinate)
        }, error: { error in
            print(error)
            Location.getLocation(accuracy: .IPScan(IPService(.freeGeoIP)), frequency: .oneShot, success: { ipLocation in
                self.postDrive(coordinate: ipLocation.1.coordinate)
            }, error: { error in
                print(error)
            }).resume()
        }).resume()
    }
    // MARK: - Custom Method
    func postDrive(coordinate: CLLocationCoordinate2D) {
        let params = ["car_number" : STATIC_DATA.DRIVER_INFO[DRIVER_INFO.CAR_NUMBER]!!, "phone" : STATIC_DATA.DRIVER_INFO[DRIVER_INFO.PHONE]!!, "status" : driverStatus, "lon" : String.init(format: "%.6f", (coordinate.longitude)), "lat" : String.init(format: "%.6f", (coordinate.latitude))]
        AlamofireManager.sharedInstance.manager.request(URL_APP_API.POST_DRIVER_COORDINATE, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseString(completionHandler: {
            response in
//            print(response.result.value!)
        })
    }

    func auctionButtonTouched(bookingId: String, priceBuy: String, priceMax: String, timeRemain: TimeInterval) {
        self.notiCheckWhoWin(date: Date().addingTimeInterval(5), bookingId: bookingId)
        if bookingId == "-2" {
            SwiftMessages.show(title: "Lỗi", message: "Không thể đấu giá nhiều chuyến cùng lúc!", layout: .MessageViewIOS8, theme: .error)
        }
        else {
            if bookingId == "-1" || timeRemain <= 0 {
                SwiftMessages.show(title: "Lỗi", message: "Đã hết thời gian đấu giá!", layout: .MessageViewIOS8, theme: .error)
            }
            else {
                if canAuction! {

                    let ticketAuction = tickets.first(where: {t in
                        return t.id == bookingId
                    })
                    if (ticketAuction?.dateFromDate)! <= Date.current() {
                        SwiftMessages.show(title: "Lỗi", message: "Đã hết thời gian đấu giá!", layout: .MessageViewIOS8, theme: .error)
                        return
                    }

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
    }

    func buyNowButtonTouched(bookingId: String, priceBuy: String, timeRemain: TimeInterval) {
        if bookingId == "-2" {
            SwiftMessages.show(title: "Lỗi", message: "Không thể đấu giá nhiều chuyến cùng lúc!", layout: .MessageViewIOS8, theme: .error)
        }
        else {
            if bookingId == "-1" || timeRemain <= 0 {
                SwiftMessages.show(title: "Lỗi", message: "Đã hết thời gian đấu giá!", layout: .MessageViewIOS8, theme: .error)
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
    }

    func auction(bookingId: String, priceAuction: String, type: String) {

        AlamofireManager.sharedInstance.manager.request(URL_APP_API.BOOKING_FINAL, method: HTTPMethod.post, parameters: ["id_booking" : bookingId, "id_driver" : STATIC_DATA.DRIVER_INFO[DRIVER_INFO.ID]!!, "driver_number" : STATIC_DATA.DRIVER_INFO[DRIVER_INFO.CAR_NUMBER]!!, "driver_phone" : STATIC_DATA.DRIVER_INFO[DRIVER_INFO.PHONE]!!, "price" : priceAuction, "type" : type], encoding: JSONEncoding.default, headers: nil).responseString(completionHandler: { response in
            switch response.result.value! {
            case "1":
                print("thành công")
                SwiftMessages.show(title: "Đấu giá thành công", message: "Hãy chờ kết quả đấu giá", layout: .MessageViewIOS8, theme: .success)
                let userDefault = UserDefaults.standard
                userDefault.set(Date(), forKey: "nextTimeAuction")
                userDefault.synchronize()
                if type == "1" {
                    self.checkWhoWin(bookingId: bookingId)
                }
                self.getMoneyDriver()
            case "0":
                print("đã có người mua")
                SwiftMessages.show(title: "Đấu giá thất bại", message: "Đã có người mua trước", layout: .MessageViewIOS8, theme: .error)
            case "-1":
                print("Lỗi mạng")
                SwiftMessages.show(title: "Lỗi mạng", message: "Hãy thử lại", layout: .MessageViewIOS8, theme: .error)
            default:
                break
            }
        })
    }


    func checkWhoWin(bookingId: String) {
        AlamofireManager.sharedInstance.manager.request(URL_APP_API.WHO_WIN_DRIVER, method: HTTPMethod.post, parameters: ["id_booking" : bookingId, "id_driver" : STATIC_DATA.DRIVER_INFO[DRIVER_INFO.ID]!!], encoding: JSONEncoding.default, headers: nil).responseString(completionHandler: { response in
            let result = response.result.value!
            if result.characters.count > 10 {
                let resultInfo = result.components(separatedBy: "_")
                let resultAlert: UIAlertController = UIAlertController(title: "Người thắng:", message: "Số điện thoại: \(resultInfo[0]), thắng chuyến xe số: #\(resultInfo[1]), Số tiền còn lại: \(resultInfo[2].customNumberStyle()) đồng", preferredStyle: UIAlertControllerStyle.alert)
                let dismiss = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    resultAlert.dismiss(animated: true, completion: nil)
                })
                resultAlert.addAction(dismiss)
                self.present(resultAlert, animated: true, completion: nil)
            }
            else {
                switch result {
                case "-1":
                    print("Lỗi mạng")
                //                SwiftMessages.show(title: "Lỗi mạng", message: "Hãy thử lại", layout: .MessageViewIOS8, theme: .error)
                case "-2":
                    print("Thua")
                    SwiftMessages.show(title: "", message: "Hiện tại bạn chưa phải người thắng đấu giá", layout: .MessageViewIOS8, theme: .error)
                default:
                    break
                }
            }
        })
    }

    func getMoneyDriver() {
        AlamofireManager.sharedInstance.manager.request(URL_APP_API.GET_MONEY_DRIVER, method: HTTPMethod.post, parameters: ["id_driver" : STATIC_DATA.DRIVER_INFO[DRIVER_INFO.ID]!!], encoding: JSONEncoding.default, headers: nil).responseString(completionHandler: {response in
            self.moneyLabel.text = response.result.value!.customNumberStyle() + " đồng"
        })
    }

    func notiCheckWhoWin(date: Date, bookingId: String) {
        let userInfo = ["bookingId": bookingId]

        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Đã hết thời gian đấu giá"
            content.body = "Xem kết quả đấu giá ngay."
            content.userInfo = userInfo
            content.sound = UNNotificationSound.default()

            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(in: .current, from: date)
            let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)

            let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            center.add(request) {(error) in
                if let error = error {
                    print("Uh oh! We had an error: \(error)")
                }
            }
        }
        else {
            // iOS 9
            let notification = UILocalNotification()
            notification.fireDate = date
            notification.alertBody = "Đã hết thời gian đấu giá. Xem kết quả đấu giá ngay."
            notification.userInfo = userInfo
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }


}

extension DriverAuction: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        SwiftMessages.show(title: "Test", message: "Hết thời gian đấu giá", layout: .CardView, theme: .error)
    }
}
