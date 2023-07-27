//
//  BaseNC.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import UIKit

class BaseNC: UINavigationController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = false
    }
}
