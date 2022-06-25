//
//  AppFont.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 8.06.2022.
//

import Foundation
import UIKit

struct AppFont {
    static let openSans = "Verdana"
    static let openSansLight = "Verdana"
    static let openSansSemibold = "Verdana-Bold"
    static let openSansBold = "Verdana-Bold"
    static let medium = UIFont(name: openSansSemibold, size: 10).required()
    static let xlight = UIFont(name: openSansLight, size: 12).required()
    static let light = UIFont(name: openSansLight, size: 13).required()
    static let biglight = UIFont(name: openSansLight, size: 16).required()
    static let smallBook = UIFont(name: openSans, size: 10).required()
    static let book = UIFont(name: openSans, size: 12).required()
    static let normalBook = UIFont(name: openSans, size: 13).required()
    static let normalBookPlus = UIFont(name: openSans, size: 14).required()
    static let normalBookExtraPlus = UIFont(name: openSans, size: 15).required()
    static let bigBook = UIFont(name: openSans, size: 16).required()
    static let menu = UIFont(name: openSans, size: 17).required()
    static let veryBigBook = UIFont(name: openSans, size: 20).required()
    static let verySmallMedium = UIFont(name: openSansSemibold, size: 6).required()
    static let smallMedium = UIFont(name: openSansSemibold, size: 12).required()
    static let smallMediumPlus = UIFont(name: openSansSemibold, size: 13).required()
    static let bigMedium = UIFont(name: openSansSemibold, size: 14).required()
    static let bigMediumExtra = UIFont(name: openSansSemibold, size: 15).required()
    static let veryBigMedium = UIFont(name: openSansSemibold, size: 16).required()
    static let xlBigMedium = UIFont(name: openSansSemibold, size: 19).required()
    static let xxlBigMedium = UIFont(name: openSansSemibold, size: 24).required()
    static let bold = UIFont(name: openSansBold, size: 12).required()
    static let boldMedium = UIFont(name: openSansBold, size: 14).required()
    static let smallBold = UIFont(name: openSansSemibold, size: 8).required()
    static let veryBigBold = UIFont(name: openSansSemibold, size: 20).required()
    static let bigBold = UIFont(name: openSansSemibold, size: 14).required()
    static let littleBigBook = UIFont(name: openSans, size: 15).required()

    // MARK: NewUX Typography

    enum Size: Int {
        case headline1 = 38
        case headline2 = 30
        case title1 = 24
        case title2 = 20
        case body1 = 16
        case body2 = 15
        case caption1 = 14
        case caption2 = 13
        case caption3 = 12
        case caption4 = 11
        case caption5 = 10
    }

    enum Style: String {
        case regular = "Verdana"
        case light = "Verdana-Light"
        case semiBold = "Verdana-Semibold"
        case bold = "Verdana-Bold"
    }
}

extension UIFont {
    convenience init(_ size: AppFont.Size, _ style: AppFont.Style) {
        let fontSize = Self.calculateDeviceSpecificFontSize(pointSize: CGFloat(size.rawValue))
        self.init(name: style.rawValue, size: fontSize)!
    }
}
