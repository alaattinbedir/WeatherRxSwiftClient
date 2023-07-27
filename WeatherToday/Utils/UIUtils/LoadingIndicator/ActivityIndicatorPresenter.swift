//
//  ActivityIndicatorPresenter.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import Lottie
import SnapKit
import UIKit

public final class ActivityIndicatorData {
    let size: CGSize
    let message: String?
    let messageFont: UIFont
    let textColor: UIColor
    let padding: CGFloat
    let displayTimeThreshold: Int
    let minimumDisplayTime: Int
    let backgroundColor: UIColor

    public init(size: CGSize? = nil,
                message: String? = nil,
                messageFont: UIFont? = nil,
                padding: CGFloat? = nil,
                displayTimeThreshold: Int? = nil,
                minimumDisplayTime: Int? = nil,
                backgroundColor: UIColor? = nil,
                textColor: UIColor? = nil) {
        self.size = size ?? CGSize(width: 60, height: 60)
        self.message = message
        self.messageFont = messageFont ?? UIFont.systemFont(ofSize: 16.0)
        self.padding = padding~
        self.displayTimeThreshold = displayTimeThreshold~
        self.minimumDisplayTime = minimumDisplayTime~
        self.backgroundColor = backgroundColor ?? UIColor.black.alpha(0.84)
        self.textColor = textColor ?? .white
    }
}

public final class ActivityIndicatorPresenter {
    enum State {
        case waitingToShow
        case showed
        case waitingToHide
        case hidden
    }

    private let restorationIdentifier = "ActivityIndicatorViewContainer"
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var state: State = .hidden
    private let startAnimatingGroup = DispatchGroup()
    public static let sharedInstance = ActivityIndicatorPresenter()

    private init() {
        // For singleton pattern
    }

    public final func startAnimating(_ data: ActivityIndicatorData) {
        guard state == .hidden else { return }

        state = .waitingToShow
        startAnimatingGroup.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(data.displayTimeThreshold)) {
            guard self.state == .waitingToShow else {
                self.startAnimatingGroup.leave()
                return
            }
            self.show(with: data)
            self.startAnimatingGroup.leave()
        }
    }

    public final func stopAnimating() {
        hide2()
    }

    public final func setMessage(_ message: String?) {
        guard state == .showed else {
            startAnimatingGroup.notify(queue: DispatchQueue.main) {
                self.messageLabel.text = message
            }
            return
        }
        messageLabel.text = message
    }

    private func show(with indicatorData: ActivityIndicatorData) {
        let containerView = UIView(frame: UIScreen.main.bounds)

        containerView.backgroundColor = indicatorData.backgroundColor
        containerView.restorationIdentifier = restorationIdentifier
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let activityIndicatorView = UIView()
        activityIndicatorView.backgroundColor = .clear

        let viewOrnamental = AnimationView(name: "generic_loading")
        viewOrnamental.contentMode = .scaleAspectFit
        viewOrnamental.loopMode = .loop
        activityIndicatorView.addSubview(viewOrnamental)
        viewOrnamental.snp.makeConstraints { $0.edges.equalToSuperview() }
        activityIndicatorView.layoutIfNeeded()
        viewOrnamental.play()

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.contentMode = .scaleAspectFit
        containerView.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(140)
            make.center.equalToSuperview()
        }

        messageLabel.font = indicatorData.messageFont
        messageLabel.textColor = indicatorData.textColor
        messageLabel.text = indicatorData.message
        containerView.addSubview(messageLabel)

        messageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(-8)
            make.trailing.equalToSuperview().offset(8)
            make.top.equalTo(activityIndicatorView.snp.bottom).offset(8)
        }

        guard let keyWindow = UIApplication.shared.keyWindow else { return }

        keyWindow.addSubview(containerView)
        state = .showed

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(indicatorData.minimumDisplayTime)) {
            self.hide2()
        }
    }

    private func hide2() {
        if state == .waitingToHide {
            hide()
        } else if state == .waitingToShow {
            state = .hidden
        } else if state != .hidden {
            state = .waitingToHide
        }
    }

    private func hide() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }

        for item in keyWindow.subviews
        where item.restorationIdentifier == restorationIdentifier {
            item.removeFromSuperview()
        }
        state = .hidden
    }
}
