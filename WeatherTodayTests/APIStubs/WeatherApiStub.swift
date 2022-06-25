//
//  WeatherApiStub.swift
//  WeatherTodayTests
//
//  Created by Alaattin Bedir on 1.06.2022.
//

@testable import WeatherToday
import Foundation
import ObjectMapper


class WeatherApiStub: WeatherApi {

    override func fetchWeather(latitude: (Double),
                               longitude: (Double),
                               success: @escaping (WeatherResponse) -> Void,
                               failure: @escaping (MyError) -> Void) {
        let response = WeatherResponse()
        success(response)
    }
}

