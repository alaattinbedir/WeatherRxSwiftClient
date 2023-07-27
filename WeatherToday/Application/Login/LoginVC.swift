//
//  LoginVC.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class LoginVC: BaseVC<LoginViewModel> {
    @IBOutlet var pfDomain: PickerFormField!
    @IBOutlet var tfUserName: TextFormField!
    @IBOutlet var tfEmail: TextFormField! {
        didSet {
            tfEmail.textField.keyboardType = .emailAddress
        }
    }

    @IBOutlet var tfPassword: TextFormField! {
        didSet {
            tfPassword.textField.keyboardType = .default
            tfPassword.textField.isSecureTextEntry = true
        }
    }

    @IBOutlet var btnSoftOtp: MyButton!
    @IBOutlet var btnContinue: MyButton!
    lazy var btnBiometricLogin = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setDomainList()
        hideNavigationBar()
        clearBackground()
        configureUI()
        setPicker()
    }

    override func bind() {
        super.bind()
        bindTextFields()
        bindSoftOtp()
        bindContinueButton()
        bindBiometricLoginButton()
        notificationObserves()
    }

    private func notificationObserves() {
        NotificationCenter.default.rx.notification(.activationDidComplete)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.configureUI()
            })
            .disposed(by: viewModel.disposeBag)

        NotificationCenter.default.rx.notification(.otpVerifiedDidComplete)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.configureUI()
            })
            .disposed(by: viewModel.disposeBag)
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .activationDidComplete, object: nil)
        NotificationCenter.default.removeObserver(self, name: .otpVerifiedDidComplete, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SessionKeeper.shared.isAutoBiometricLoginActive,
           viewModel.isBiometricLoginAvailable.value {
            viewModel.biometricAuth()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }

    override func onStateChanged(_ state: ViewState) {
        guard let state = state as? LoginViewState else { return }
        switch state {
        case .openMenu:
            openMenu()
        case let .openSmsOtpPage(data):
            guard let data = data else { return }
            openSmsOtpPage(data: data)
        case .openOtpPage:
            openOtpPage()
        }
    }

    override func onAlertButtonPressed(_ code: Alert?, buttonIdentifier: AlertButtonIdentifier) {
        switch (code, buttonIdentifier) {
        case (.loginError1, _),
            (.loginError2, _):
            viewModel.email.accept("")
            viewModel.password.accept("")
            KeychainKeeper.shared.email = ""
            KeychainKeeper.shared.isUserRegistered = false
            configureUI()
        default:
            super.onAlertButtonPressed(code, buttonIdentifier: buttonIdentifier)
        }
    }

    private func configureUI() {
        viewModel.userName.accept(KeychainKeeper.shared.userName)
        viewModel.password.accept("")
        tfPassword.textField.text = ""
        tfEmail.isHidden = KeychainKeeper.shared.isUserRegistered
        tfPassword.isHidden = !KeychainKeeper.shared.isUserRegistered
        btnSoftOtp.isHidden = !(KeychainKeeper.shared.isUserRegistered && !KeychainKeeper.shared.softOtpPinNumber.isEmptyOrNil)
        tfUserName.textField.text = KeychainKeeper.shared.userName~
        if KeychainKeeper.shared.isUserRegistered {
            tfEmail.textField.text = KeychainKeeper.shared.email
        }
        btnContinue.resource = KeychainKeeper.shared.isUserRegistered ? .loginLoginButton : .loginContinueButton
        configureBiometricLoginButton()
    }

    private func setPicker() {
        let selectedIndex = (KeychainKeeper.shared.domain?.isEmpty)~ ? 0 : viewModel.findDomainIndex()
        pfDomain.configurePickerItems(items: viewModel.domains.value,
                                      selectedIndex: selectedIndex)
    }

    private func openMenu() {
        NavigationRouter.present(from: self,
                                 to: MainPageVC(),
                                 embedController: .navigation,
                                 animated: false)
    }

    private func openSmsOtpPage(data: LoginSmsOtpViewModelData) {
        NavigationRouter.present(from: self,
                                 to: LoginSmsOtpVC(),
                                 presentationStyle: .popover,
                                 data: data)
    }

    private func openOtpPage() {
        NavigationRouter.present(from: self,
                                 to: PinEnterVC(),
                                 presentationStyle: .popover,
                                 data: SoftOtpGenerateViewModelData(expiresIn: SoftOtpConstants.period))
    }

    private func saveUserInfos() {
        KeychainKeeper.shared.userName = tfUserName.textField.text?.trimmingWhitespace()
        KeychainKeeper.shared.domain = viewModel.domains.value[pfDomain.selectedIndex.value~]
        KeychainKeeper.shared.userNameWithDomain = viewModel.getUserNameWithDomain().trimmingWhitespace()

        if !KeychainKeeper.shared.isUserRegistered {
            KeychainKeeper.shared.email = tfEmail.textField.text?.trimmingWhitespace()
        }
    }

    private func configureBiometricLoginButton() {
        let image = BiometricAuthenticationManager.shared.getBiometricType().menuIcon
        let buttonSize: CFloat = 24
        btnBiometricLogin.setImage(image, for: .normal)
        btnBiometricLogin.setImage(image, for: .highlighted)
        btnBiometricLogin.addTarget(self, action: #selector(biometricLoginButtonTapped), for: .touchUpInside)
        btnBiometricLogin.sizeToFit()
        btnBiometricLogin.snp.makeConstraints {
            $0.height.equalTo(buttonSize)
            $0.width.equalTo(buttonSize)
        }
        tfPassword.textField.rightView = btnBiometricLogin
        tfPassword.textField.rightViewMode = .always
    }

    @objc
    private func biometricLoginButtonTapped() {
        viewModel.biometricAuth()
    }

    override func setResources() {
        pfDomain.titleResource = .loginDomainHeader
        tfUserName.titleResource = .loginUsername
        tfPassword.titleResource = .loginPassword
        tfEmail.titleResource = .loginEmail
        btnSoftOtp.resource = .loginSMSOTPButton
    }
}

// MARK: Binding

private extension LoginVC {
    func bindTextFields() {
        (tfUserName.textField.rx.text <-> viewModel.userName).disposed(by: viewModel.disposeBag)
        (tfEmail.textField.rx.text <-> viewModel.email).disposed(by: viewModel.disposeBag)
        tfPassword.textField.rx.text.bind(to: viewModel.password).disposed(by: viewModel.disposeBag)
    }

    func bindSoftOtp() {
        btnSoftOtp.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.isSoftOtpTapped = true
                self.viewModel.getOtp()
            })
            .disposed(by: viewModel.disposeBag)
    }

    func bindContinueButton() {
        viewModel.canContinue
            .bind(to: btnContinue.rx.isEnabled)
            .disposed(by: viewModel.disposeBag)

        btnContinue.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.saveUserInfos()
                self.view.endEditing(true)
                if KeychainKeeper.shared.isUserRegistered {
                    self.viewModel.login()
                } else {
                    self.viewModel.isSoftOtpTapped = false
                    KeychainKeeper.shared.deleteSoftOtpActivation()
                    self.viewModel.getOtp()
                }
            })
            .disposed(by: viewModel.disposeBag)
    }

    func bindBiometricLoginButton() {
        viewModel.isBiometricLoginAvailable.map { !$0 }.bind(to: btnBiometricLogin.rx.isHidden).disposed(by: viewModel.disposeBag)
    }
}
