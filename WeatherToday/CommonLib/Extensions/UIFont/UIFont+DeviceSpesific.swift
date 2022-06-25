//
//  UIFont+DeviceSpesific.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 8.06.2022.
//

import Foundation
import UIKit

public extension UIFont {
    private static let referenceSize: CGFloat = 375.0
    func deviceSpecific() -> UIFont {
        let referenceSize: CGFloat = 375.0
        if UIScreen.main.bounds.width < referenceSize {
            let newPointSize = UIScreen.main.bounds.width * pointSize / referenceSize
            return UIFont(name: fontName, size: newPointSize).required()
        } else {
            return self
        }
    }

    static func calculateDeviceSpecificFontSize(referenceSize: CGFloat = 375, pointSize: CGFloat) -> CGFloat {
        if UIScreen.main.bounds.width < referenceSize {
            return UIScreen.main.bounds.width * pointSize / referenceSize
        } else {
            return pointSize
        }
    }
}
