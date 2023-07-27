//
//  WarningView.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import Foundation
import IQKeyboardManagerSwift
import TextAttributes

protocol WarningViewDelegate: AnyObject {
    func onAlertButtonPressed(_ code: Alert?, buttonIdentifier: AlertButtonIdentifier)
}

class WarningView {
    var model: AlertModel?
    weak var delegate: WarningViewDelegate?
    var alert: WarningVC?
    var attributes: TextAttributes?
    var buttonStyle: ((UIButton, Int) -> Void)?
    var dismissHandler: (() -> Void)?

    init(model: AlertModel, delegate: WarningViewDelegate? = nil, attributes: TextAttributes? = nil) {
        self.model = model
        self.delegate = delegate
        alert = WarningVC()
        self.attributes = attributes
    }

    func show() {
        guard let model = model else { return }
        IQKeyboardManager.shared.resignFirstResponder()
        alert?.show(data: WarningViewModelData(attributes: attributes,
                                               model: model,
                                               buttonTappedHandler: buttonHandler))
    }

    func buttonHandler(index: Int) {
        guard let model = model else { return }
        dismissAlert { [weak self] in
            let alertCode = Alert(rawValue: model.code)
            self?.delegate?.onAlertButtonPressed(alertCode, buttonIdentifier: model.buttons[index].identifier)
        }
    }

    func dismissAlert(animated: Bool = true, _ handler: (() -> Void)?) {
        alert?.dismiss(animated: animated) { [weak self] in
            self?.alert = nil
            self?.dismissHandler?()
            handler?()
        }
    }
}
