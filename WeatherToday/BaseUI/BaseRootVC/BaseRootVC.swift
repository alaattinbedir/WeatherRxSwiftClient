//
//  BaseRootVC.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import CoreMotion
import SnapKit
import UIKit

class BaseRootVC: BaseDataViewController, UINavigationControllerDelegate {
    @IBOutlet var containerView: UIView!

    var viewControllers: [UIViewController] = []
    var activeNavigationController: UINavigationController? {
        didSet {
            activeNavigationController?.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addContentController()
        addViewControllers()
        setAccessibilityIdentifiers()
    }

    private func addContentController() {
        let baseNC = BaseNC(rootViewController: UIViewController())
        addChild(baseNC)
        baseNC.view.frame = containerView.bounds
        containerView.addSubview(baseNC.view)
        baseNC.didMove(toParent: self)
        activeNavigationController = navigationController
    }

    private func addViewControllers() {
        if let navigationController = children.first as? UINavigationController {
            navigationController.viewControllers = viewControllers
        }
    }

    private func setAccessibilityIdentifiers() {
        // eklenecek
    }
}
