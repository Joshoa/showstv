//
//  BaseViewController.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 01/07/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let screenTimeManager = ScreenTimeManager.shared

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenTimeManager.screenTimeCounter(state: .started, viewController: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        screenTimeManager.screenTimeCounter(state: .stopped, viewController: self)
    }
}
