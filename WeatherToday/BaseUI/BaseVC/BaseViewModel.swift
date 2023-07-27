//
//  BaseViewModel.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import Foundation
import UIKit
import RxSwift

protocol ViewState {}

class BaseViewModel {
    let disposeBag = DisposeBag()

    var state = PublishSubject<ViewState>()
    var alert = PublishSubject<AlertModel>()

    public required init() {
        // Intentionally unimplemented
    }

    deinit {
        print("*** \(String(describing: type(of: self))) deinitialized")
    }

    func handleFailure(_ model: ErrorMessage) {
        let title = (model.title?.isEmpty) ?? true ? ResourceKey.generalErrorHeader.value : model.title
        let alertModel = AlertModel(title: title,
                                    message: model.message,
                                    icon: StatusCodeType.error.icon,
                                    code: (model.code)~)
        alert.onNext(alertModel)
    }
}

extension BaseViewModel {
    func showGenericError(message: String?, code: Int = 0) {
        alert.onNext(AlertModel(title: ResourceKey.generalErrorHeader.value,
                                message: message,
                                icon: StatusCodeType.error.icon,
                                buttons: [.ok],
                                code: code))
    }

    func showGenericWarning(message: String?, code: Int = 0) {
        alert.onNext(AlertModel(title: ResourceKey.generalWarningHeader.value,
                                message: message,
                                icon: StatusCodeType.warning.icon,
                                buttons: [.ok],
                                code: code))
    }

    func showGenericCompletion(message: String?, code: Int = 0) {
        alert.onNext(AlertModel(title: ResourceKey.generalCompleteHeader.value,
                                message: message,
                                icon: StatusCodeType.success.icon,
                                buttons: [.ok],
                                code: code))
    }
}

