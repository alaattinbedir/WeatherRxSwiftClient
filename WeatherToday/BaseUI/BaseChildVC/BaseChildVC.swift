//
//  BaseChildVC.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import UIKit

class BaseChildVC<T>: BaseVC<T> where T: BaseViewModel {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = navigationController {
            getRootVC()?.activeNavigationController = navigationController
        }
    }

    override func getRootVC() -> BaseRootVC? {
        var viewController: UIViewController? = self

        while viewController?.parent != nil {
            if let rootVC = viewController?.parent as? BaseRootVC {
                return rootVC
            }
            viewController = viewController?.parent
        }
        if let rootVC = presentingViewController?.parent as? BaseRootVC {
            return rootVC
        }
        return nil
    }
}
