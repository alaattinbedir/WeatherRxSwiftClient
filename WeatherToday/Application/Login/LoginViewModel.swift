//
//  LoginViewModel.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import RxCocoa
import RxSwift

enum LoginViewState: ViewState {
    case openMenu
    case openSmsOtpPage(LoginSmsOtpViewModelData?)
    case openOtpPage
}

class LoginViewModel: BaseViewModel {
    let loginApi: LoginAPI
    let biometricAuthApi: BiometricAuthAPI
    var domains = BehaviorRelay<[String]>(value: [])
    var userName = BehaviorRelay<String?>(value: "")
    var password = BehaviorRelay<String?>(value: "")
    var email = BehaviorRelay<String?>(value: "")
    var canContinue = BehaviorRelay<Bool>(value: false)
    var isBiometricLoginAvailable = BehaviorRelay<Bool>(value: false)
    var isSoftOtpTapped: Bool = false

    required convenience init() {
        self.init(loginApi: LoginAPI(), biometricAuthApi: BiometricAuthAPI())
        bind()
        checkBiometricLoginAvailable()
    }

    init(loginApi: LoginAPI, biometricAuthApi: BiometricAuthAPI) {
        self.loginApi = loginApi
        self.biometricAuthApi = biometricAuthApi
    }

    private func bind() {
        Observable.combineLatest(userName, password, email)
            .map { [weak self] userName, password, email in
                guard let self = self else { return false }
                return self.validate(userName: userName, password: password, email: email)
            }
            .bind(to: canContinue)
            .disposed(by: disposeBag)
    }

    private func validate(userName: String?,
                          password: String?,
                          email: String?) -> Bool {
        let isUserNameEmpty = userName~.count < 3
        let isPasswordEmpty = password~.count < 3
        let isValidEmail = EmailValidator().validate(email) == .succeeded
        var isValid = false
        if KeychainKeeper.shared.isUserRegistered {
            isValid = !isUserNameEmpty && !isPasswordEmpty
        } else {
            isValid = !isUserNameEmpty && isValidEmail
        }
        return isValid
    }

    func getOtp() {
        let request = OtpRequest(userName: (KeychainKeeper.shared.userNameWithDomain~).encrypt(),
                                 email: (KeychainKeeper.shared.email?.encrypt())~)
        loginApi.getOtp(params: request.toDict(),
                        succeed: parseOtp,
                        failed: handleFailure)
    }

    private func parseOtp(response: OtpResponse) {
        let viewData = LoginSmsOtpViewModelData(otpResponse: response)
        if isSoftOtpTapped {
            state.on(.next(LoginViewState.openOtpPage))
        } else {
            state.on(.next(LoginViewState.openSmsOtpPage(viewData)))
        }
    }

    func login() {
        let request = LoginRequest(userName: (KeychainKeeper.shared.userNameWithDomain?.encrypt())~,
                                   password: password.value~.trimmingWhitespace().encrypt())
        loginApi.login(params: request.toDict(),
                       succeed: parseLogin,
                       failed: handleFailure)
    }

    private func parseLogin(_ response: LoginResponse) {
        SessionKeeper.shared.userFullName = response.fullName
        SessionKeeper.shared.userTitle = response.title
        KeychainKeeper.shared.email = response.email
        SessionKeeper.shared.isUserLoggedIn = true
        state.onNext(LoginViewState.openMenu)
    }

    func getUserNameWithDomain() -> String {
        let selectedDomain = KeychainKeeper.shared.domain~
        let domain = selectedDomain + "\\"
        let userNameWithDomain = "\(domain)\(userName.value~)"
        return userNameWithDomain
    }

    func findDomainIndex() -> Int {
        for (index, domain) in domains.value.enumerated() {
            if domain == KeychainKeeper.shared.domain {
                return index
            }
        }
        return 0
    }

    func setDomainList() {
        domains.accept(ResourceKey.loginDomainList.value.components(separatedBy: ";").filter { !$0.isEmpty })
    }
}

// MARK: - Biometric Login

extension LoginViewModel {
    private func checkBiometricLoginAvailable() {
        let isCanUseBiometric = BiometricAuthenticationManager.shared.canEvaluatePolicy() == nil
        let isAvailable = isCanUseBiometric && KeychainKeeper.shared.isBiometricIdRegistered && KeychainKeeper.shared.isUserRegistered
        isBiometricLoginAvailable.accept(isAvailable)
    }

    func biometricAuth() {
        let biometricType = String(PersistentKeeper.shared.biometricType.rawValue)
        BiometricAuthenticationManager.shared.evaluatePolicy(reason: .biometricLoginPopUpLogin(biometricType),
                                                             completionHandler: handleBiometricAuthResult)
    }

    func handleBiometricAuthResult(isSuccess: Bool, _: BiometricAuthError?) {
        if isSuccess {
            loginWithBiometric()
        }
    }

    private func loginWithBiometric() {
        let request = BiometricLoginRequest(userName: getUserNameWithDomain().trimmingWhitespace().encrypt(),
                                            biometricRegisterId: KeychainKeeper.shared.biometricRegisterId?.encrypt())
        biometricAuthApi.biometricLogin(request: request,
                                        succeed: parseLogin,
                                        failed: handleFailure)
    }
}
