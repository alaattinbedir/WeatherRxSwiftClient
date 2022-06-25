//
//  AppDomain.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 8.06.2022.
//


enum AppDomain: Codable, CaseIterable, RawRepresentable {

    static var allCases: [AppDomain] {
        return [
            .production,
            .development,
            .custom(AppDomain.production.domainUrl)
        ]
    }

    case production
    case development
    case custom(String)


    public var rawValue: String { domainUrl }

    public init?(rawValue: String) {
        var domain: AppDomain?
        for item in AppDomain.allCases where item.domainUrl == rawValue {
            domain = item
            break
        }
        self = domain ?? .custom(rawValue)
    }

    var domainName: String {
        return (domainUrl).replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "http://", with: "")
            .replacingOccurrences(of: "/api", with: "")
    }

    var domainUrl: String {
        switch self {
        case .production:
            return "https://api.darksky.net/forecast/2bb07c3bece89caf533ac9a5d23d8417/"
        case .development:
            return "https://api.darksky.net/forecast/2bb07c3bece89caf533ac9a5d23d8417/"
        case let .custom(ip):
            return ip
        }
    }

    var msisdnUrl: String {
        return "\(domainUrl)/auth/msisdn".replacingOccurrences(of: "https", with: "http")
    }
}
