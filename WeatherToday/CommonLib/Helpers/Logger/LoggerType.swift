//
//  MDLoggerType.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 8.06.2022.
//

import Foundation

public protocol LoggerType: AnyObject {
    func w(tag: String, _ items: Any..., error: Error?)
    func e(tag: String, _ items: Any..., error: Error)
    func i(tag: String, _ items: Any...)
    func v(tag: String, _ items: Any...)
    func analytic(event: LoggerEvent)
}
