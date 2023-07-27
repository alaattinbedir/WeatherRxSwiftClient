//
//  Constants.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import UIKit

enum Key {
#if STORE
    static let AppGroupId = "group.mydenizbank"
#else
    static let AppGroupId = "group.mydenizbank.internal"
#endif

    enum UserDefaults {
        static let hasAppRunBefore = "hasAppRunBefore"
        static let localeVersion = "localeVersion"
        static let isJailBroken = "isJailBroken"
        static let lastCheckedAppVersion = "lastCheckedAppVersion"
        static let langDict = "langDict"
        static let isAppRunningTest = "APP-IS-RUNNING-TEST"
        static let biometricType = "biometricType"
    }

    enum Keychain {
        static let serviceName = "com.intertech.MyDenizBank.keychainService"
        static let localIP = "LocalIP"
        static let uniqueDeviceId = "UniqueDeviceID"
        static let userId = "userId"
        static let domain = "SAVE_LOGIN_DOMAIN_DATESTRING"
        static let userName = "USER_NAME"
        static let userNameWithDomain = "USER_NAME_WITH_DOMAIN"
        static let email = "EMAIL"
        static let hasActivationCompleted = "HAS_ACTIVATION_COMPLETED"
        static let isUserRegistered = "isUserRegistered"
        static let biometricRegisterId = "biometricRegisterId"
        static let isBiometricIdRegistered = "isBiometricIdRegistered"
        static let softOtpPinNumber = "softOtpPinNumber"
        static let activationCode = "activationCode"
    }
}

enum AppFont {
    static let black = "Alexandria-Black"
    static let bold = "Alexandria-Bolxs"
    static let extraBold = "Alexandria-ExtraBold"
    static let extraLight = "Alexandria-ExtraLight"
    static let light = "Alexandria-Light"
    static let medium = "Alexandria-Medium"
    static let regular = "Alexandria-Regular"
    static let semiBold = "Alexandria-SemiBold"
    static let thin = "Alexandria-Thin"

    static let regular14 = UIFont(name: AppFont.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    static let medium12 = UIFont(name: AppFont.medium, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    static let medium16 = UIFont(name: AppFont.medium, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
    static let medium20 = UIFont(name: AppFont.medium, size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
    static let bold20 = UIFont(name: AppFont.bold, size: 20.0) ?? UIFont.boldSystemFont(ofSize: 20.0)
    static let bold30 = UIFont(name: AppFont.bold, size: 30.0) ?? UIFont.boldSystemFont(ofSize: 30.0)
    static let extraBold20 = UIFont(name: AppFont.extraBold, size: 20.0) ?? UIFont.boldSystemFont(ofSize: 20.0)
    static let extraBold30 = UIFont(name: AppFont.extraBold, size: 30.0) ?? UIFont.boldSystemFont(ofSize: 30.0)
}

enum DateFormat: String {
    case ddMMyyyy = "dd/MM/yyyy"
    case ddMMyyyyWithoutSlash = "ddMMyyyy"
    case ddMMyyyyDotted = "dd.MM.yyyy"
    case ddMMyyyyHHmm = "dd/MM/yyyy HH:mm"
    case ddMMyy = "dd/MM/yy"
    case yyyyMMdd = "yyyy-MM-dd"
    case ddMMyyyy2 = "dd-MM-yyyy"
    case dMMMMyyyy = "d MMMM yyyy"
    case ddMMMMyyyy = "dd MMMM yyyy"
    case yyyy
    case MMMM
    case hhmm = "HH:mm"
    case gitiso = "YYYY-MM-DD hh:mm:ss Z"
    case HHmmEEEE = "HH:mm EEEE"
    case serviceResponseFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
    case serviceRequestFormat = "yyyy-MM-dd'T'HH:mm:ss"
    case serviceResponseFormat2 = "dd.MM.yyyy HH:mm:ss"
    case ddMMMM = "dd MMMM"
    case ddMMyyyyWithSpace = "dd / MM / yyyy"
    case documentDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    case yyyyMMddWithSlash = "yyyy/MM/dd"
}

enum FieldMargin {
    static let margin12: CGFloat = 12
    static let margin16: CGFloat = 16
    static let margin20: CGFloat = 20
    static let margin24: CGFloat = 24
    static let margin28: CGFloat = 28
}

enum SoftOtpConstants {
    static let period: Double = 30.0
    static let digitsCount: Int = 8
    static let pinDigitsCount: UInt = 6
}

enum CustomDimensions {
    static let inputAccessoryHeight: CGFloat = 44
}
