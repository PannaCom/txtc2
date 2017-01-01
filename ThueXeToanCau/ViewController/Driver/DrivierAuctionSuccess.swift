//
//  DriverAuctionSucces.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 1/1/17.
//  Copyright © 2017 AnhHT. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import RxCocoa
import ESPullToRefresh
import Alamofire
import DropDown

class DriverAuctionSuccess: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var backButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var tableView: UITableView!
    var tickets = [PassengerTicket]()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.expriedTimeInterval = 10.0

        backButton.rx.tap
            .subscribe(onNext: {self .dismiss(animated: true, completion: nil)})
            .addDisposableTo(disposeBag)

        let _ = tableView.es_addPullToRefresh { [weak self] in
            let params:Dictionary<String, String> = ["phone" : STATIC_DATA.DRIVER_INFO[DRIVER_INFO.PHONE] as! String]
            Alamofire.request(URL_APP_API.GET_BOOKING_SUCCESS, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
                if let ticketResponse = JSON(response.result.value!).array {
                    for ticket in ticketResponse {
                        let ticket = PassengerTicket.init(withJSON: ticket)
                        self?.tickets.append(ticket)
                    }
                    self?.tableView.reloadData()
                    self?.tableView.es_stopPullToRefresh()
                }
            })
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.es_startPullToRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID.DRIVER_AUCTION_SUCCESS, for: indexPath) as? DriverBookingCell {
            cell.updateUI(ticket: tickets[indexPath.row])
            cell.selectionStyle = .none
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
