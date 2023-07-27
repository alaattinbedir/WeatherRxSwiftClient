//
//  RequestBodyConvertible+Default.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//


import Foundation

extension RequestBodyConvertible where Self: Encodable {
    func toDict() -> [String: Any]? {
        return ObjectConverter.convert(toDict: self)
    }
}
