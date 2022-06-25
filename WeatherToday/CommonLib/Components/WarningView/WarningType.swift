//
//  WarningType.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 7.06.2022.
//

import Foundation

enum WarningType: Int {
    case success = 0
    case warning = 1
    case failed = 2
    case inform = 3
    case authorization = 4
    case commonNetworkError = 5
    case question = 6

    init(directionTypeName: String?) {
        guard let directionTypeName = directionTypeName else {
            self = .warning
            return
        }

        switch directionTypeName {
        case "error":
            self = .failed
        default:
            self = .warning
        }
    }
}
