//
//  AlertManager.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import Foundation
import IQKeyboardManagerSwift
import RxSwift
import RxCocoa
import TextAttributes

class AlertManager {
    static let shared = AlertManager()

    var warningView: WarningView?
    var keyboardConstraint: NSLayoutConstraint?
    var keyboardHeight: CGFloat = 0.0
    let bag = DisposeBag()

    func build(with model: AlertModel) -> WarningView? {
        warningView = WarningView(model: model, attributes: nil)
        warningView?.dismissHandler = { [weak self] in
            self?.warningView = nil
        }
        return warningView
    }
}

extension StatusCodeType {
    var icon: UIImage {
        switch self {
        case .warning:
            return #imageLiteral(resourceName: "yellowExclamationmarkOctagon").with(size: 40)
        case .info:
            return #imageLiteral(resourceName: "blueInfoSquare").with(size: 40)
        case .success:
            return #imageLiteral(resourceName: "greenCheckMarkCircle").with(size: 40)
        case .error, .unknown:
            return #imageLiteral(resourceName: "redExclamationmarkTriangle").with(size: 40)
        }
    }
}

extension WarningView {
    func delegate(_ delegate: WarningViewDelegate) -> WarningView {
        self.delegate = delegate
        return self
    }
}
