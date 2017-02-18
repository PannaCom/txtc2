//
//  DriverGetBooking.swift
//  ThueXeToanCau
//
//  Created by AnhHT on 12/17/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit
import RxSwift
import RxSwift
import SwiftyJSON
import RxCocoa
import ESPullToRefresh
import Alamofire

class DriverGetBooking: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var backButton: UIButton!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var bookingThuaKhachButton: UIButton!
    @IBOutlet var bookingFindPassengerButton: UIButton!
    @IBOutlet var footerView: UIView!
    var lastContentOffsetY: CGFloat = 0

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
            AlamofireManager.sharedInstance.manager.request(URL_APP_API.GET_LIST_BOOKING_LOG, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID.DRIVER_BOOKING, for: indexPath) as? DriverBookingCell {
            cell.updateUI(ticket: tickets[indexPath.row])
            cell.selectionStyle = .none
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: SEGUE_ID.SHOW_LOG_BOOKING, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_ID.SHOW_LOG_BOOKING {
            let vc:DriverLogPassengerBooking = segue.destination as! DriverLogPassengerBooking
            let ticket:PassengerTicket = tickets[(tableView.indexPathForSelectedRow?.row)!]
            vc.id_booking = ticket.id
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView {

            if (lastContentOffsetY > scrollView.contentOffset.y && scrollView.contentOffset.y < scrollView.contentSize.height - 2*tableView.rowHeight) || scrollView.contentOffset.y <= 0{
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

}

