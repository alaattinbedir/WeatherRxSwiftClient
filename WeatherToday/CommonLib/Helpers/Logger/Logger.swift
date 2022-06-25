//
//  Logger.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 8.06.2022.
//

import Foundation

public class Logger: LoggerType {
    public static let shared: Logger = {
        let logger = Logger()
        return logger
    }()

    private var loggers: [LoggerType] = []

    public func w(tag: String, _ items: Any..., error: Error?) {
        loggers.forEach { $0.w(tag: tag, items, error: error) }
    }

    public func e(tag: String, _ items: Any..., error: Error) {
        loggers.forEach { $0.e(tag: tag, items, error: error) }
    }

    public func i(tag: String, _ items: Any...) {
        loggers.forEach { $0.i(tag: tag, items) }
    }

    public func v(tag: String, _ items: Any...) {
        loggers.forEach { $0.v(tag: tag, items) }
    }

    public func analytic(event: LoggerEvent) {
        loggers.forEach { $0.analytic(event: event) }
    }

    public func addNewLogger(_ logger: LoggerType) {
        loggers.append(logger)
    }

    public func removeLogger(_ logger: LoggerType) {
        loggers.removeAll { $0 === logger }
    }
}
