//
//  Keeper.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 8.06.2022.
//

import Foundation

class Keeper {
    static let shared = Keeper()

    var currentEnvironment: AppDomain = .production {
        didSet {
            if let appGroupUserDefault = UserDefaults(suiteName: "CurrentEnvironment") {
                appGroupUserDefault
                    .set(currentEnvironment.domainUrl, forKey: "DomainUrl")
            }
        }
    }
}
