//
//  AlertModel.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import Foundation

import UIKit

class AlertModel: NSObject {
    var title: String?
    var message: String?
    var code: Int = 0
    var field: String?
    var icon: UIImage?
    var textAlignment: NSTextAlignment = .center
    var textFont: UIFont?
    var buttons: [AlertButtonTag] = [.ok]
    var status: StatusCodeType = .unknown {
        didSet { icon = icon ?? status.icon }
    }

    var enableCloseButton: Bool = false
    var enableTrimAttributedString: Bool?

    override init() {
        // Intentionally unimplemented
    }

    convenience init(title: ResourceKey? = nil,
                     message: ResourceKey? = nil,
                     icon: UIImage? = nil,
                     textAlignment: NSTextAlignment = .center,
                     textFont: UIFont? = nil,
                     buttons: [AlertButtonTag] = [.ok],
                     code: Int = 0,
                     enableCloseButton: Bool = false,
                     enableTrimAttributedString: Bool? = nil) {
        self.init(title: title?.value,
                  message: message?.value,
                  icon: icon,
                  textAlignment: textAlignment,
                  textFont: textFont,
                  buttons: buttons,
                  code: code,
                  enableCloseButton: enableCloseButton,
                  enableTrimAttributedString: enableTrimAttributedString)
    }

    convenience init(title: String? = nil,
                     message: String? = nil,
                     icon: UIImage? = nil,
                     textAlignment: NSTextAlignment = .center,
                     textFont: UIFont? = nil,
                     buttons: [AlertButtonTag] = [.ok],
                     code: Int = 0,
                     enableCloseButton: Bool = false,
                     enableTrimAttributedString: Bool? = nil) {
        self.init()
        self.title = title
        self.message = message
        self.textAlignment = textAlignment
        self.textFont = textFont
        self.icon = icon
        self.buttons = buttons
        self.code = code
        self.enableCloseButton = enableCloseButton
        self.enableTrimAttributedString = enableTrimAttributedString
    }
}
