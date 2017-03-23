//
//  DriverGetTransaction.swift
//  ThueXeToanCau
//
//  Created by Hoang Tuan Anh on 24/03/2017.
//  Copyright © 2017 AnhHT. All rights reserved.
//

import UIKit
import M13Checkbox

class DriverGetTransaction: UIViewController {
    
    @IBOutlet weak var biensoTextField: UITextField!
    @IBOutlet weak var showDetailCheckbox: M13Checkbox!
    @IBOutlet weak var dateFromTextField: UITextField!
    @IBOutlet weak var dateToTextField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDetailCheckbox.stateChangeAnimation = .bounce(.fill)
        showDetailCheckbox.markType = .checkmark
    }
}
