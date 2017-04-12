//
//  SplashViewController.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/23/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SwiftMessages

class SplashViewController: UIViewController {

    @IBOutlet var progressIndicator: UIActivityIndicatorView!
    @IBOutlet var infoLabel: UILabel!

    var airportList: NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()

        reload()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        progressIndicator.isHidden = false
        infoLabel.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


    }

    func reload(){
        progressIndicator.startAnimating()
        loadData() { isSuccess in
            print("loadData: \(isSuccess)")
            self.progressIndicator.stopAnimating()
            if isSuccess {
                let userDefault = UserDefaults.standard
                let userRole = userDefault.string(forKey: USER_DEFAULT_DATA.USER_ROLE)
                let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)

                if userRole == nil || userRole?.characters.count == 0 {
                    self.performSegue(withIdentifier: "gotoSelectRoleSegueId", sender: self)
                }
                else {
                    if userRole == USER_ROLE.PASSENGER {
                        let mainPassengerVc = mainStoryboard.instantiateViewController(withIdentifier: STORYBOARD_ID.PASSENGER_SELECT_ACTIVITY)
                        self.present(mainPassengerVc, animated: true, completion: nil)
                    }
                    if userRole == USER_ROLE.DRIVER {

                        AlamofireManager.sharedInstance.manager.request(URL_APP_API.LOGIN, method: HTTPMethod.post, parameters: ["phone" : userDefault.string(forKey: DRIVER_INFO.PHONE)!, "pass" : userDefault.string(forKey: DRIVER_INFO.PASS)!], encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { response in

                            if response.result.isSuccess {
                                if let values:Array = JSON(response.result.value!).arrayObject {
                                    if values.count > 0 {
                                        STATIC_DATA.DRIVER_INFO = values[0] as! Dictionary<String, Any?>
                                        let mainDriverVc = mainStoryboard.instantiateViewController(withIdentifier: STORYBOARD_ID.DRIVER_AUCTION)
                                        self.present(mainDriverVc, animated: true, completion: nil)
                                    }
                                    else{
                                        SwiftMessages.show(title:"Lỗi", message: "Không thể đăng nhập", layout: .MessageViewIOS8, theme: .error)
                                    }
                                }
                            }
                            else {
                                SwiftMessages.show(title:"Lỗi", message: "Không thể đăng nhập", layout: .MessageViewIOS8, theme: .error)
                            }
                        })

                    }
                }
            }
            else {
                let errorAlert = UIAlertController.init(title: "Lỗi kết nối", message: "Hãy kiểm tra cài đặt mạng của bạn", preferredStyle: UIAlertControllerStyle.alert)
                let actionAlert = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    errorAlert.dismiss(animated: true, completion: nil)
                    self.reload()
                })
                errorAlert.addAction(actionAlert)

                self.present(errorAlert, animated: true, completion: nil)

            }
        }
    }

    func loadData(completion: @escaping (_ isSuccess: Bool) -> Void) {
        let group = DispatchGroup()
        var isSuccessAll = true;
        group.enter()
        getDataInputFromURL(url: URL_APP_API.GET_CAR_HIRE_TYPE){ (result: NSArray, isSuccess: Bool) in
            if isSuccess {
                STATIC_DATA.CAR_HIRE_TYPE = result
            }
            else {
                isSuccessAll = false
            }

            group.leave()
        }

        group.enter()
        getDataInputFromURL(url: URL_APP_API.GET_CAR_SIZE){ (result: NSArray, isSuccess: Bool) in
            if isSuccess {
                let r:NSMutableArray = []
                for i: String in result as! [String] {
                    if i == "4" {
                        r.add("4 chỗ (giá siêu rẻ, không cốp)")
                    }
                    else if i == "5" {
                        r.add(i + " chỗ (có cốp)")
                    }
                    else{
                        r.add(i + " chỗ")
                    }
                }
                STATIC_DATA.CAR_SIZE = r
            }
            else {
                isSuccessAll = false
            }

            group.leave()
        }

        group.enter()
        getDataInputFromURL(url: URL_APP_API.GET_WHO_HIRE) { (result: NSArray, isSuccess: Bool) in
            if isSuccess {
                STATIC_DATA.WHO_HIRE = result
            }
            else {
                isSuccessAll = false
            }

            group.leave()
        }

        group.enter()
        getDataInputFromURLwithJSON(url: URL_APP_API.GET_AIRPORT) { (result: NSArray, isSuccess: Bool) in
            if isSuccess {
                self.airportList = []
                for airportName in result {
                    group.enter()

                    AlamofireManager.sharedInstance.manager.request(URL_APP_API.GET_LONLAT_AIRPORT, method: .post, parameters: ["airport":airportName], encoding: URLEncoding.default, headers: nil).responseJSON{ response in
                        let r:NSArray = response.result.value as! NSArray
                        let dict = r[0] as! NSDictionary
                    
                        let airport = Airport(airportName: airportName as! String, lon1: self.stringFromNumber(number: dict.value(forKey: "lon1") as! NSNumber), lat1: self.stringFromNumber(number: dict.value(forKey: "lat1") as! NSNumber), lon2: self.stringFromNumber(number: dict.value(forKey: "lon2") as! NSNumber), lat2: self.stringFromNumber(number: dict.value(forKey: "lat2") as! NSNumber))
                        self.airportList.add(airport)
                        group.leave()
                    }
                }

            }
            else {
                isSuccessAll = false
            }

            group.leave()
        }

        group.enter()
        getDataInputFromURLwithJSON(url: URL_APP_API.GET_NOTICE) { (result: NSArray, isSuccess: Bool) in
            if isSuccess {
                STATIC_DATA.NOTICE = result
            }
            else {
                isSuccessAll = false
            }

            group.leave()
        }

        group.enter()
        getDataInputFromURL(url: URL_APP_API.GET_CAR_TYPE, completion: { (result: NSArray, isSuccess: Bool) in
            if isSuccess {
                STATIC_DATA.CAR_TYPE = result
            }
            else {
                isSuccessAll = false
            }
            group.leave()
        })

        group.enter()
        getDataInputFromURLwithJSON(url: URL_APP_API.GET_CAR_MADE, completion: { (result: NSArray, isSuccess: Bool) in
            if isSuccess {
                STATIC_DATA.CAR_MADE = result
            }
            else {
                isSuccessAll = false
            }
            group.leave()
        })

        group.notify(queue: .main, execute: {
            if isSuccessAll {
                STATIC_DATA.AIRPORT = self.airportList
            }

            completion(isSuccessAll)
        })

    }

    func getDataInputFromURL(url: String, completion: @escaping (_ result: NSArray, _ isSuccess: Bool) -> Void) {
       /*
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "GET"
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: [], options: [])
        urlRequest.setValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")


        AlamofireManager.sharedInstance.manager.request(urlRequest).responseJSON { response in
            if response.result.isFailure {
                print("Error Load Data: \(response.result.error)")
            }
            if response.result.isSuccess {
                completion (response.result.value as! NSArray, true)
            }
            else {
                completion ([], false)
            }
        }
        */
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding(), headers: nil).responseJSON(completionHandler: {
            response in
            if response.result.isFailure {
                print("Error Load Data: \(String(describing: response.result.error))")
            }
            if response.result.isSuccess {
                completion (response.result.value as! NSArray, true)
            }
            else {
                completion ([], false)
            }
        })
    }

    func getDataInputFromURLwithJSON(url: String, completion: @escaping (_ result: NSArray,_ isSuccess: Bool) -> Void) {

     /*
            AlamofireManager.sharedInstance.manager.request(url).responseJSON { response in

            if response.result.isSuccess {
                let r:NSArray = response.result.value as! NSArray
                completion (r.value(forKey: "name") as! NSArray, true)
            }
            else {
                completion ([], false)
            }
        }
 */
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding(), headers: nil).responseJSON(completionHandler: {
            response in
            if response.result.isSuccess {
                let r:NSArray = response.result.value as! NSArray
                completion (r.value(forKey: "name") as! NSArray, true)
            }
            else {
                completion ([], false)
            }
        })
    }

    func stringFromNumber(number: NSNumber) -> String{
        return String.init(format: "%.6f", number.floatValue)
    }
}
