//
//  NSNotification+Extension.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 7.06.2022.
//

import Foundation

public extension NSNotification.Name {
    static let mdOnLanguageCodeChanged: NSNotification.Name = NSNotification.Name("mdOnLanguageCodeChanged")
    static let mdNewNotificationHandled: NSNotification.Name = NSNotification
        .Name("NotificationCenterKeyForNewNotification")
    static let mdNotificationsClear: NSNotification.Name = NSNotification.Name("mdNotificationsClear")
    static let mdServiceRequestSent: NSNotification.Name = NSNotification.Name("mdServiceRequestSent")
    static let mdDashboardHeaderLoaded: NSNotification.Name = NSNotification.Name("mdDashboardHeaderLoaded")
    static let mdPushAnimationEnded: NSNotification.Name = NSNotification.Name("mdPushAnimationEnded")
    static let mdPushAnimationWillStart: NSNotification.Name = NSNotification.Name("mdPushAnimationWillStart")
    static let mdVcWillAppear: NSNotification.Name = NSNotification.Name("mdVcWillAppear")
    static let mdReStartOTPCycle: NSNotification.Name = NSNotification.Name("reStartOTPCycle")
    static let mdResultPageOpened: NSNotification.Name = NSNotification.Name("mdResultPageOpened")
    static let mdChangeCardSwipeIndex: NSNotification.Name = NSNotification.Name("changeCardSwipeIndex")
    static let mdScreenActivityIndicatorStarted: NSNotification.Name = NSNotification
        .Name("mdScreenActivityIndicatorStarted")
    static let mdScreenActivityIndicatorEnded: NSNotification.Name = NSNotification
        .Name("mdScreenActivityIndicatorStarted")
    static let noCardFoundDissmissed: NSNotification.Name = NSNotification.Name("noCardFoundDissmissed")
    static let mdFavouriteCardChanged: NSNotification.Name = NSNotification.Name("mdFavouriteCardChanged")
    static let mdFavouriteAccountChanged: NSNotification.Name = NSNotification.Name("mdFavouriteAccountChanged")
    static let mdChatbotQuickAction: NSNotification.Name = NSNotification.Name("NotificationCenterKeyChatbotUserSays")

    static let mdCreateUserFirstVCLoad: NSNotification.Name = NSNotification.Name("mdCreateUserFirstVCLoad")
    static let mdCreateUserFirstVCReceived: NSNotification.Name = NSNotification.Name("mdCreateUserFirstVCReceived")
    static let mdUserUpdateQuickMenu: NSNotification.Name = NSNotification.Name("mdUserUpdateQuickMenu")

    func post() {
        NotificationCenter.default.post(name: self, object: nil)
    }
}
