//
//  ScreenActivityIndicator.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 8.06.2022.
//

import Foundation
import UIKit

class ScreenActivityIndicator {
    static let shared = ScreenActivityIndicator()

    let activityIndicator: ActivityIndicatorData

    private init() {
        activityIndicator = ActivityIndicatorData(size: CGSize(width: 60, height: 60),
                                                  message: nil, messageFont: nil,
                                                  padding: nil,
                                                  displayTimeThreshold: nil,
                                                  minimumDisplayTime: 1,
                                                  backgroundColor: UIColor(red: 0.29, green: 0.29, blue: 0.29,
                                                                           alpha: 0.30),
                                                  textColor: nil)
    }

    func startAnimating() {
        if !ActivityIndicatorPresenter.sharedInstance.isAnimating() {
            UIAccessibility
                .post(notification: UIAccessibility.Notification.announcement,
                      argument: "VoiceOver.LoadingText")
        }

        ActivityIndicatorPresenter.sharedInstance.startAnimating(activityIndicator)
    }

    func stopAnimating() {
        if ActivityIndicatorPresenter.sharedInstance.isAnimating() {
            UIAccessibility
                .post(notification: UIAccessibility.Notification.announcement,
                      argument: "VoiceOver.LoadedText")
        }
        ActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }

    func isAnimating() -> Bool {
        return ActivityIndicatorPresenter.sharedInstance.isAnimating()
    }
}
