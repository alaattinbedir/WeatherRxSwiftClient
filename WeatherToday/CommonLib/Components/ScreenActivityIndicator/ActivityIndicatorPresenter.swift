//
//  ActivityIndicatorPresenter.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 8.06.2022.
//

import UIKit
import SnapKit
import Lottie

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
        self.size = size ?? CGSize(width: 330, height: 330)
        self.message = message
        self.messageFont = messageFont ?? AppFont.bigBook
        self.padding = padding ?? 0.0
        self.displayTimeThreshold = displayTimeThreshold ?? 0
        self.minimumDisplayTime = minimumDisplayTime ?? 0
        self.backgroundColor = backgroundColor ?? UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.textColor = textColor ?? .white
    }
}

public final class ActivityIndicatorPresenter {
    private enum State {
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

    private var state: State = .hidden
    private let startAnimatingGroup = DispatchGroup()
    public static let sharedInstance = ActivityIndicatorPresenter()

    private init() {
        // Empty function body
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
        changeStatusToHide()
    }

    public final func isAnimating() -> Bool {
        return state != .hidden
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
        containerView.alpha = 0.0
        containerView.accessibilityIdentifier = "loadingAnimation"

        let rocketView = AnimationView(name: "loading")
        rocketView.layer.masksToBounds = true
        rocketView.contentMode = .scaleAspectFit
        rocketView.translatesAutoresizingMaskIntoConstraints = false
        rocketView.backgroundBehavior = .pauseAndRestore
        containerView.addSubview(rocketView)

        rocketView.snp.makeConstraints { make in
            make.width.equalTo(indicatorData.size.width)
            make.height.equalTo(indicatorData.size.height)
            make.center.equalToSuperview()
        }

        messageLabel.font = indicatorData.messageFont
        messageLabel.textColor = indicatorData.textColor
        messageLabel.text = indicatorData.message
        containerView.addSubview(messageLabel)

        messageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(-8)
            make.trailing.equalToSuperview().offset(8)
            make.top.equalTo(rocketView.snp.bottom).offset(8)
        }

        guard let keyWindow = UIApplication.shared.keyWindow else { return }

        keyWindow.addSubview(containerView)
        state = .showed

        UIView.animate(withDuration: 0.2) {
            containerView.alpha = 1.0
        }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        rocketView.loopMode = .loop
        rocketView.play()

        NotificationCenter.default
            .post(Notification(name: NSNotification.Name.mdScreenActivityIndicatorStarted, object: nil))

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(indicatorData.minimumDisplayTime)) {
            self.changeStatusToHide()
        }
    }

    private func changeStatusToHide() {
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
            UIView.animate(withDuration: 0.2, animations: {
                item.alpha = 0.0
            }, completion: { _ in
                item.removeFromSuperview()
            })

            NotificationCenter.default
                .post(Notification(name: NSNotification.Name.mdScreenActivityIndicatorStarted, object: nil))
        }
        state = .hidden
    }
}
