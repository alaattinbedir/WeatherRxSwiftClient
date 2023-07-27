//
//  BaseField.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import UIKit
import RxSwift
import RxCocoa

class BaseField: UIView, NibLoadable {
    override func awakeAfter(using _: NSCoder) -> Any? {
        return loadFromNibIfEmbeddedInDifferentNib()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        bind()
    }

    func bind() {
        layoutIfNeeded()
    }

    func bindHide(relay: BehaviorRelay<Bool>, bag: DisposeBag) -> BaseField {
        relay.subscribe { [weak self] hidden in
            self?.isHidden = hidden
        }.disposed(by: bag)
        return self
    }
}

