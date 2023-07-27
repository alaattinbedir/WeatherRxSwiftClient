//
//  ScreenActivityIndicator.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import UIKit

final class ScreenActivityIndicator {
    static let shared = ScreenActivityIndicator()

    let activityIndicator: ActivityIndicatorData

    private init() {
        activityIndicator = ActivityIndicatorData(size: CGSize(width: 60, height: 60),
                                                  message: nil,
                                                  messageFont: nil,
                                                  padding: nil,
                                                  displayTimeThreshold: nil,
                                                  minimumDisplayTime: 1,
                                                  backgroundColor: UIColor.blackSeven,
                                                  textColor: nil)
    }

    func startAnimating() {
        ActivityIndicatorPresenter.sharedInstance.startAnimating(activityIndicator)
    }

    func stopAnimating() {
        ActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }

    func isAnimating() -> Bool {
        return ActivityIndicatorPresenter.sharedInstance.state == .showed || ActivityIndicatorPresenter.sharedInstance.state == .waitingToHide
    }
}
