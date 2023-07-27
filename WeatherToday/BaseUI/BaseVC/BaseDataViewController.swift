//
//  BaseDataViewController.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import Foundation
import UIKit

class BaseDataViewController: UIViewController {
    var menuPageTitle: String?

    var data: ViewModelData? {
        didSet { dataUpdated() }
    }

    func dataUpdated() {
        // Intentionally unimplemented
    }

    func getRootVC() -> BaseRootVC? {
        nil
    }
}
