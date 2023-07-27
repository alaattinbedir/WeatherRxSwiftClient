//
//  Alert.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import Foundation

enum Alert: Int {
    case networkIsNotReachable
    case loginError1 = 1010
    case loginError2 = 1014
    case localIp
    case jailbreakDetection
    case logOff
    case biometricLoginActivated
    case biometricLoginCancelled
    case biometricLoginCancel
    case biometricLoginError
    case openSettings
    case activationCompleted
    case pinChanged
    case createRemoteWorkProcess
    case checkAllFields
    case wrongDate
    case createNewCustomer
    case saveVisit
    case successfullyDelegatedInfo
    case deleteDelegateWarning
    case unknownError = 100_000
    case unauthorizedServiceCall = 100_002
    case sessionExpired = 100_003
    case checkSumInvalid = 100_004

    var model: AlertModel {
        switch self {
        case .localIp:
            return AlertModel(title: "Hay aksi!",
                              message: "IP adresini girmen gerekiyor.",
                              icon: StatusCodeType.error.icon,
                              buttons: [.ok],
                              code: rawValue)
        case .jailbreakDetection:
            return AlertModel(message: "Cihazınızın rootlu olduğu tespit edildi. Yine de devam etmek istiyor musunuz?",
                              buttons: [.ok, .cancel],
                              code: rawValue)
        case .logOff:
            return AlertModel(title: .generalWarningHeader,
                              message: .mainpageLogOffText,
                              icon: StatusCodeType.warning.icon,
                              buttons: [.cancel, .exit],
                              code: rawValue)
        case .biometricLoginActivated:
            let biometricTypeStr = String(PersistentKeeper.shared.biometricType.rawValue)
            return AlertModel(title: .biometricLoginID(biometricTypeStr),
                              message: .biometricLoginPopUpMessage(biometricTypeStr),
                              icon: StatusCodeType.success.icon,
                              buttons: [.ok],
                              code: rawValue)
        case .biometricLoginCancelled:
            let biometricTypeStr = String(PersistentKeeper.shared.biometricType.rawValue)
            return AlertModel(title: .biometricLoginID(biometricTypeStr),
                              message: .biometricLoginCancelInfo(biometricTypeStr),
                              icon: StatusCodeType.success.icon,
                              buttons: [.ok],
                              code: rawValue)
        case .biometricLoginCancel:
            let biometricTypeStr = String(PersistentKeeper.shared.biometricType.rawValue)
            return AlertModel(title: .biometricLoginID(biometricTypeStr),
                              message: .biometricLoginPopUpCancel(biometricTypeStr),
                              icon: StatusCodeType.warning.icon,
                              buttons: [.cancel, .ok],
                              code: rawValue)
        case .openSettings:
            let biometricTypeStr = String(PersistentKeeper.shared.biometricType.rawValue)
            return AlertModel(title: .generalWarningHeader,
                              message: .biometricLoginPermission(biometricTypeStr),
                              icon: StatusCodeType.warning.icon,
                              buttons: [.cancel, .settings],
                              code: rawValue)
        case .activationCompleted:
            return AlertModel(title: .generalCompleteHeader,
                              message: .softOtpCompleteInfo(KeychainKeeper.shared.userName~),
                              icon: StatusCodeType.success.icon,
                              buttons: [.ok],
                              code: rawValue)
        case .pinChanged:
            return AlertModel(title: .generalCompleteHeader,
                              message: .softOtpChangeCompleteInfo,
                              icon: StatusCodeType.success.icon,
                              buttons: [.ok],
                              code: rawValue)
        case .checkAllFields:
            return AlertModel(title: .generalWarningHeader,
                              message: .remoteWorkWarningAllText,
                              icon: StatusCodeType.warning.icon,
                              buttons: [.ok],
                              code: rawValue)
        case .successfullyDelegatedInfo:
            return AlertModel(title: .delegationCompleted,
                              message: .delegationCompletedText,
                              icon: StatusCodeType.success.icon,
                              buttons: [.ok],
                              code: rawValue)
        case .deleteDelegateWarning:
            return AlertModel(title: .delegationWarning,
                              message: .delegationWarningText,
                              icon: StatusCodeType.warning.icon,
                              buttons: [.cancel, .ok],
                              code: rawValue)
        default:
            return AlertModel()
        }
    }

    func with(_ model: AlertModel) -> AlertModel {
        model.code = rawValue
        switch self {
        default:
            break
        }
        return model
    }

    func navigate(with tag: AlertButtonIdentifier) {
        switch (self, tag) {
        case (.unknownError, .ok),
            (.sessionExpired, _),
            (.checkSumInvalid, _):
            SessionKeeper.shared.clearSessionForLogoff()
            NavigationRouter.go(to: SplashVC(),
                                transitionOptions: TransitionOptions(direction: .fade))
        case (.unauthorizedServiceCall, _):
            SessionKeeper.shared.clearSessionForLogoff()
            NavigationRouter.go(to: LoginVC(),
                                transitionOptions: TransitionOptions(direction: .fade))
        default:
            break
        }
    }
}

enum AlertButtonTag {
    case ok
    case cancel
    case exit
    case settings

    var resource: ResourceKey {
        switch self {
        case .ok:
            return .generalOKButton
        case .cancel:
            return .generalCancelButton
        case .exit:
            return .generalExitButton
        case .settings:
            return .biometricLoginSettingsButton
        }
    }

    var identifier: AlertButtonIdentifier {
        switch self {
        case .ok:
            return .ok
        case .cancel:
            return .cancel
        case .exit:
            return .exit
        case .settings:
            return .settings
        }
    }

    var style: MyButtonStyle {
        switch self {
        case .cancel:
            return .secondaryStyle
        default:
            return .primaryStyle
        }
    }
}

enum AlertButtonIdentifier: String {
    case none
    case ok
    case cancel
    case exit
    case settings
}
