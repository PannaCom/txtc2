//
//  DriverLogPassengerBooking.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 1/2/17.
//  Copyright © 2017 AnhHT. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import RxCocoa
import ESPullToRefresh
import Alamofire

class DriverLogPassengerBooking: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var id_booking: String = ""
    var logPassengers = [LogPassenger]()
    let disposeBag = DisposeBag()
    @IBOutlet var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backButton.rx.tap
            .subscribe(onNext:{
                self.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
        let _ = tableView.es_addPullToRefresh { [weak self] in
            let params = ["id_booking" : (self?.id_booking)!]
            AlamofireManager.sharedInstance.manager.request(URL_APP_API.GET_BOOKING_LOG, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
                self?.tableView.es_stopPullToRefresh()
                if response.result.isSuccess {
                    if let ticketResponse = JSON(response.result.value!).array {
                        for log in ticketResponse {
                            let log = LogPassenger.init(json: log)
                            self?.logPassengers.append(log)
                        }
                        self?.tableView.reloadData()
                    }
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.es_startPullToRefresh()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "driverLogPassengerCellId", for: indexPath) as? LogPassengerCell {
            cell.updateUI(logPassenger: logPassengers[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logPassengers.count
    }

}
