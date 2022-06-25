//
//  ActivityIndicatorLoadableView.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 8.06.2022.
//

import Foundation
import SnapKit
import Lottie

protocol ActivityIndicatorLoadableView {
    var activityIndicator: AnimationView { get }
    func showActivityIndicator(width: CGFloat, height: CGFloat)
    func hideActivityIndicator()
}

extension ActivityIndicatorLoadableView where Self: UIView {
    func showActivityIndicator(width: CGFloat, height: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.activityIndicator.backgroundColor = .clear
            self.activityIndicator.animation = Animation.named("loading")
            self.activityIndicator.masksToBounds = true
            self.activityIndicator.contentMode = .scaleAspectFit
            self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.activityIndicator.backgroundBehavior = .pauseAndRestore
            self.addSubview(self.activityIndicator)
            self.activityIndicator.snp.makeConstraints { make in
                make.width.equalTo(width)
                make.height.equalTo(height)
                make.center.equalToSuperview()
            }
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.activityIndicator.alpha = 1.0
            }
            self.activityIndicator.loopMode = .loop
            self.activityIndicator.play()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.activityIndicator.alpha = 0.0
            }, completion: { [weak self] _ in
                self?.activityIndicator.stop()
                self?.activityIndicator.removeFromSuperview()
            })
        }
    }
}

