//
//  EnumCaseName.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 6.06.2022.
//

import Foundation

public protocol EnumCaseName {
    var caseName: String { get }
}

public extension EnumCaseName {
    var caseName: String {
        var name = String(describing: self)
        if let startIndex = name.firstIndex(of: "(") {
            name = String(name[name.startIndex ..< startIndex])
        }
        return name
    }
}
