//
//  Dictionary+Mapping.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 8.06.2022.
//

import Foundation

public extension Dictionary where Key == Value {
    func getValueOrKey(key: Key) -> Value {
        if let value = self[key] {
            return value
        }
        return key
    }
}
