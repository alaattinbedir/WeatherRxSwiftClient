//
//  WarningManager.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 7.06.2022.
//

import Foundation
import IQKeyboardManagerSwift


protocol WarningViewDelegate: AnyObject {
    func warningView(_ warning: WarningView, tappedButtonIndex: Int)
}

class WarningView {
    var title: String = ""
    var message: String = ""
    var type: WarningType = .warning
    var buttonTitles: [String] = [String]()
    var buttonActions: [(title: String, action: () -> Void)] = []
    weak var delegate: WarningViewDelegate?
    var tag: Int = 0
    let alert: SCLAlertView
    var popBack = false
    var popupIcon: UIImage?

    init(title: String = "Warning Title", message: String, delegate: WarningViewDelegate?, type: WarningType, buttonTitles: [String]) {
        self.title = title
        self.message = message
        self.type = type
        self.buttonTitles = buttonTitles
        self.delegate = delegate
        popupIcon = WarningView.getIconImage(for: type)

        let appearance = SCLAlertView.SCLAppearance(
            kCircleBackgroundTopPosition: (popupIcon != nil) ? 55 : 0,
            kCircleHeight: (popupIcon != nil) ? 56 : 0,
            kCircleIconHeight: (popupIcon != nil) ? 52.5 : 0,
            kTitleTop: (popupIcon != nil) ? 95 : 25,
            kWindowWidth: UIScreen.main.bounds.size.width - 32,
            kTextViewdHeight: 120,
            kButtonHeight: 56,
            kTitleFont: AppFont.medium.withSize(20),
            kTextFont: AppFont.book.withSize(17),
            kButtonFont: AppFont.book.withSize(18),
            showCloseButton: false,
            circleBackgroundColor: UIColor.clear,
            titleColor: WarningView.getTitleColor(for: type), textColor: AppColor.greyishBrown
        )

        alert = SCLAlertView(appearance: appearance)
    }

    convenience init(title: String = "WarningTitle", message: String) {
        self.init(title: title, message: message, delegate: nil, type: .warning, buttonTitles: ["OkButton"])
    }

    convenience init(title: String = "WarningTitle", message: String, type: WarningType) {
        self.init(title: title, message: message, delegate: nil, type: type, buttonTitles: ["OkButton"])
    }

    convenience init(title: String = "WarningTitle", message: String, type: WarningType, delegate: WarningViewDelegate?) {
        self.init(title: title, message: message, delegate: delegate, type: type, buttonTitles: ["OkButton"])
    }

    convenience init(title: String = "WarningTitle", message: String, delegate: WarningViewDelegate?) {
        self
            .init(title: title, message: message, delegate: delegate, type: .warning,
                  buttonTitles: ["OkButton"])
    }

    convenience init(title: String = "WarningTitle", message: String, delegate: WarningViewDelegate?, buttonTitles: [String]) {
        self.init(title: title, message: message, delegate: delegate, type: .warning, buttonTitles: buttonTitles)
    }

    convenience init(title: String = "WarningTitle", message: String, type: WarningType = .warning,
                     buttonActions: [(title: String, action: () -> Void)] = [("OkButton", {
                         // Empty body
                     })]) {
        self.init(title: title, message: message, delegate: nil, type: type, buttonTitles: [])
        self.buttonActions = buttonActions
    }

    @discardableResult
    func clearActions() -> WarningView {
        buttonTitles.removeAll()
        buttonActions.removeAll()
        return self
    }

    @discardableResult
    func addAction(_ title: String, action: @escaping () -> Void) -> WarningView {
        buttonActions.append((title, action))
        return self
    }

    @discardableResult
    func makeTitleBackground(_ titleBgColor: UIColor) -> WarningView {
        alert.labelTitle.textColor = AppColor.greyishBrown
        alert.labelTitle.backgroundColor = titleBgColor
        return self
    }

    @discardableResult
    func makeTitleColor(_ titleTextColor: UIColor) -> WarningView {
        alert.labelTitle.textColor = titleTextColor
        return self
    }

    @discardableResult
    func setTitleFont(_ titleFont: UIFont) -> WarningView {
        alert.labelTitle.font = titleFont
        return self
    }

    @discardableResult
    func makeMessageFont(_ messageFont: UIFont) -> WarningView {
        alert.viewText.font = messageFont
        return self
    }

    @discardableResult
    func makeMessageColor(_ color: UIColor) -> WarningView {
        alert.viewText.textColor = color
        return self
    }

    func show(stopScreenIndicator: Bool = true) {
        if stopScreenIndicator {
            ScreenActivityIndicator.shared.stopAnimating()
        }

        if type == .authorization, WarningView.isShowing() {
            Logger.shared.w(tag: "WarningView", "skipped authorization alert, because already is shown currently", "message: \(message)", error: nil)
            return
        } else if type == .commonNetworkError, WarningView.isShowing() {
            return
        }

        IQKeyboardManager.shared.resignFirstResponder()

        show()

        sayVoiceOverMessage()
    }

    func alertLog() {
        if type == WarningType.warning || type == WarningType.authorization || type == WarningType.failed {
            Logger.shared.w(tag: "WarningView.\(type)", "\(title) \(message)", error: nil)
        }
    }

    // Return true if a SCLAlertView is already being shown, false otherwise
    static func isShowing() -> Bool {
        if let subviews = UIApplication.shared.keyWindow?.subviews {
            for view in subviews where view.accessibilityIdentifier == SCLAlertView.uniqueAccessibilityIdentifier {
                return true
            }
        }
        return false
    }

    public static func cancelCurrentPopups() {
        guard let subviews = UIApplication.shared.keyWindow?.subviews else { return }
        for view in subviews where view.accessibilityIdentifier == SCLAlertView.uniqueAccessibilityIdentifier {
            if let alert = view.parentContainerViewController() as? SCLAlertView {
                alert.hideView()
            }
        }
    }

    public func sayVoiceOverMessage() {
        UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: getVoiceOverMessage())
    }

    private func getVoiceOverMessage() -> String {
        return "Popup.AccessibilityText"
    }

    func getButtonBackgroundColor(type _: WarningType, index: Int) -> UIColor {
        return index == 0 ? AppColor.cerulean : AppColor.whiteDefault
    }

    func getButtonTextColor(index: Int) -> UIColor {
        return index == 0 ? AppColor.whiteDefault : AppColor.cerulean
    }

    class func getIconImage(for type: WarningType) -> UIImage? {
        return type.getIconImage()
    }

    class func getTitleColor(for type: WarningType) -> UIColor {
        switch type {
        case .success:
            return AppColor.greyishBrown
        case .warning, .authorization, .commonNetworkError:
            return UIColor(red: 241 / 255, green: 196 / 255, blue: 5 / 255, alpha: 1)
        case .failed:
            return AppColor.vermillion
        case .inform, .question:
            return AppColor.cerulean
        }
    }
}

extension SCLAlertView {
    private enum AssociatedKeys {
        static var warningType = "MD.WarningView.SCLAlertView.WarningType"
    }

    var warningType: WarningType {
        get {
            if let warningTypeValue = objc_getAssociatedObject(self, &SCLAlertView.AssociatedKeys.warningType) as? Int,
               let savedWarningType = WarningType(rawValue: warningTypeValue) {
                return savedWarningType
            }

            return .warning
        }
        set {
            objc_setAssociatedObject(self, &SCLAlertView.AssociatedKeys.warningType, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

extension WarningType {
    func getIconImage() -> UIImage? {
        switch self {
        case .success, .question:
            return UIImage(named: "onaylandi").required()
        case .warning, .failed, .inform, .authorization, .commonNetworkError:
            return nil
        }
    }
}

private extension WarningView {
    func show() {
        for index in 0 ..< buttonTitles.count {
            alert.addButton(buttonTitles[index],
                            backgroundColor: getButtonBackgroundColor(type: type, index: index),
                            textColor: getButtonTextColor(index: index),
                            showTimeout: nil) {
                self.delegate?.warningView(self, tappedButtonIndex: index)
            }
        }

        for index in 0 ..< buttonActions.count {
            alert.addButton(buttonActions[index].title,
                            backgroundColor: getButtonBackgroundColor(type: type, index: index),
                            textColor: getButtonTextColor(index: index),
                            showTimeout: nil, action: buttonActions[index].action)
        }
        alertLog()
        let responder = alert.showCustom(title,
                                         subTitle: message,
                                         color: AppColor.whiteDefault,
                                         icon: popupIcon)

        responder?.alertview.viewText.accessibilityValue = ""
        responder?.alertview.viewText.accessibilityLabel = message
        responder?.alertview.viewText.isScrollEnabled = true

        alert.warningType = type
    }
}
