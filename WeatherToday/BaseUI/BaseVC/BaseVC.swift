//
//  BaseVC.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import UIKit
import RxSwift
import RxCocoa

protocol ViewModelData {}

class BaseVC<VM>: BaseDataViewController, WarningViewDelegate, UINavigationControllerDelegate where VM: BaseViewModel {
    public lazy var viewModel: VM = VM()
    let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
    var pageTitle = BehaviorRelay<String?>(value: nil)
    var isHiddenNavigationBar: Bool = false
    private let closeButtonSize: CGFloat = 28

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        pageTitle.accept(menuPageTitle)
        configureBackground()
        subscribeViewStateChanges()
        setResources()
        setAccessibilityIdentifiers()
        print("*** \(String(describing: type(of: self))) initialized")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAppearence()
        if isHiddenNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }

    private func setAppearence() {
        let backButton = UIBarButtonItem(image: UIImage(named: "blueBack"),
                                         style: .plain,
                                         target: navigationController,
                                         action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = navigationController?.viewControllers.count == 1 ? nil : backButton
    }

    func addRightButton(image: UIImage?, action: Selector) {
        let button = UIBarButtonItem(image: image,
                                     style: .plain,
                                     target: self,
                                     action: action)
        if navigationItem.rightBarButtonItems == nil {
            navigationItem.rightBarButtonItems = []
        }
        navigationItem.rightBarButtonItems?.append(button)
    }

    func clearRightButtons() {
        navigationItem.rightBarButtonItems?.removeAll()
    }

    private func subscribeViewStateChanges() {
        viewModel.state.subscribe { [weak self] state in
            self?.onStateChanged(state)
        }.disposed(by: viewModel.disposeBag)
    }

    func onStateChanged(_: ViewState) {
        // Intentionally unimplemented
    }

    func bind() {
        viewModel.alert.subscribe(onNext: { [weak self] alertModel in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if AlertManager.shared.warningView != nil {
                    self.dismissWarningView(alertModel: alertModel, delegate: self)
                } else {
                    AlertManager.shared.build(with: alertModel)?.delegate(self).show()
                }
            }
        }).disposed(by: viewModel.disposeBag)

        pageTitle.bind(to: rx.title).disposed(by: viewModel.disposeBag)
    }

    private func dismissWarningView(alertModel: AlertModel, delegate: BaseVC<VM>) {
        AlertManager.shared.warningView?.dismissAlert {
            AlertManager.shared.build(with: alertModel)?.delegate(delegate).show()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isHiddenNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    func onAlertButtonPressed(_ code: Alert?, buttonIdentifier: AlertButtonIdentifier) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            code?.navigate(with: buttonIdentifier)
        }
    }

    func setResources() {
        // Intentionally unimplemented
    }

    func setAccessibilityIdentifiers() {
        // Intentionally unimplemented
    }

    private func configureBackground() {
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImageView, at: 0)
    }

    func clearBackground() {
        backgroundImageView.image = nil
    }

    func hideNavigationBar() {
        isHiddenNavigationBar = true
    }

    func addCloseButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "blueClose"), for: .normal)
        button.rx.tap.subscribe(onNext: { [weak self] in
            if let navigationController = self?.navigationController,
               navigationController.viewControllers.count > 1 {
                NavigationRouter.pop()
            } else {
                NavigationRouter.dismiss()
            }
        }).disposed(by: viewModel.disposeBag)
        button.frame = CGRect(x: 0, y: 0, width: closeButtonSize, height: closeButtonSize)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    deinit {
        print("*** \(String(describing: type(of: self))) deinitialized")
    }
}

