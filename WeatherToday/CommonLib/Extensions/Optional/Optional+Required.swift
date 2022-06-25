//
//  Optional+Required.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 6.06.2022.
//

import Foundation

public extension Optional where Wrapped: DefaultValue, Wrapped.DefaultType == Wrapped {
    func required() -> Wrapped {
        defer {
            if self == nil {
                assertionFailure("value can not be nil because you try to unwrap value")
            }
        }
        return valueOrDefault
    }

    var valueOrDefault: Wrapped {
        guard let notNilSelf = self else {
            return Wrapped.defaultValue
        }
        return notNilSelf
    }
}

public extension Optional {
    func required() -> Wrapped {
        guard let notNilSelf = self else {
            return self!
        }
        return notNilSelf
    }
}

public protocol DefaultValue {
    associatedtype DefaultType: DefaultValue where DefaultType.DefaultType == Self
    static var defaultValue: DefaultType { get }
}
