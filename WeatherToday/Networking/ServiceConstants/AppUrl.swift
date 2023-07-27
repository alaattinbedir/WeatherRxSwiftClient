//
//  AppUrl.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

enum AppUrl {
    static let dev = "cldevui01.intertech.com.tr"
    static let uat = "uatmydenizbank.denizbank.com"
    static let prep = "prepmydenizbank.denizbank.com"

    static var baseUrl: String {
        switch SessionKeeper.shared.currentEnvironment {
        case .local:
            return AppDomains.local.replacingOccurrences(of: "LOCAL_IP", with: KeychainKeeper.shared.localIP~)
        case .dev:
            return AppDomains.dev
        case .uat:
            return AppDomains.uat
        case .prep:
            return AppDomains.prep
        }
    }
}
