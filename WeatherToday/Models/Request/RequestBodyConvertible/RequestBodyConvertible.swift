//
//  RequestBodyConvertible.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import Foundation

protocol RequestBodyConvertible {
    func toDict() -> [String: Any]?
}
