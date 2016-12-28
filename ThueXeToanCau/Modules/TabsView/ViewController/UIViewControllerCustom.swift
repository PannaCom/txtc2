//
//  UIViewControllerCustom.swift
//  ThueXeToanCau
//
//  Created by VMio69 on 12/19/16.
//  Copyright © 2016 AnhHT. All rights reserved.
//

import UIKit

class UIViewControllerCustom: UIViewController {

    @IBOutlet var containerView: UIView!

    func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)

        // Add Child View as Subview
        containerView.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
}
