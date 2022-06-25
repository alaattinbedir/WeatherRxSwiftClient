//
//  UIView+IBInspectable.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 8.06.2022.
//

import UIKit

public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderUIColor: UIColor {
        set { layer.borderColor = newValue.cgColor }
        get { return UIColor(cgColor: layer.borderColor.required()) }
    }

    @IBInspectable var masksToBounds: Bool {
        get { return layer.masksToBounds }
        set { layer.masksToBounds = newValue }
    }

    @IBInspectable var zPosition: CGFloat {
        get { return layer.zPosition }
        set {
            layer.zPosition = newValue
        }
    }

    @IBInspectable var testAutomationIdentifier: String? {
        get { return accessibilityIdentifier }
        set { accessibilityIdentifier = newValue }
    }

    @IBInspectable var shadowColor: UIColor {
        get { return UIColor(cgColor: layer.shadowColor ?? UIColor.clear.cgColor) }
        set { layer.shadowColor = newValue.cgColor }
    }

    @IBInspectable var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
}
