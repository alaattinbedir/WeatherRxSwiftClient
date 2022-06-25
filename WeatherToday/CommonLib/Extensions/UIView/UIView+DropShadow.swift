//
//  UIView+DropShadow.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 6.06.2022.
//

import UIKit

public extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func dropShadow(color: UIColor,
                    opacity: Float = 0.5,
                    offSet: CGSize,
                    radius: CGFloat = 1,
                    scale: Bool = true,
                    bounds: CGRect? = nil) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        let bounds = bounds ?? self.bounds

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

public extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11, *) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            var masked = CACornerMask()
            if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
            if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
            if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
            if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
            self.layer.maskedCorners = masked
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }

    func removeCorners() {
        roundCorners([.allCorners], radius: 0)
    }

    func setIsHidden(_ hidden: Bool, animated: Bool, duration: TimeInterval = 0.25, animationCompletion: (() -> Void)? = nil) {
        guard isHidden != hidden else { return }
        let currentAlpha = alpha
        if animated {
            if isHidden, !hidden {
                alpha = 0.0
                isHidden = false
            }
            UIView.animate(withDuration: duration, animations: {
                self.alpha = hidden ? 0.0 : currentAlpha
            }, completion: { _ in
                self.isHidden = hidden
                if hidden {
                    self.alpha = currentAlpha
                }
                animationCompletion?()
            })
        } else {
            isHidden = hidden
        }
    }

    func setAlpha(_ alpha: CGFloat, animated: Bool, duration: TimeInterval = 0.25, isAutoDismiss: Bool = false) {
        guard alpha != self.alpha else { return }
        let currentAlpha = alpha
        if animated {
            if self.alpha == 0.0, currentAlpha != 0.0 {
                isHidden = false
            }
            UIView.animate(withDuration: duration, animations: {
                self.alpha = currentAlpha
                self.layoutIfNeeded()
            }, completion: { _ in
                if isAutoDismiss {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.setAlpha(0.0, animated: true)
                    }
                }
                if currentAlpha == 0.0 {
                    self.isHidden = true
                }
            })
        } else {
            self.alpha = currentAlpha
            isHidden = currentAlpha == 0.0 ? true : false
        }
    }
}
