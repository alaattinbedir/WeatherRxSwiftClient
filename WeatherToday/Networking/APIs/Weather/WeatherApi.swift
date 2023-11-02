//
//  WeatherApi.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 26.11.2021.
//

import Foundation
import MLNetworking

// MARK: - Weather model extension

class WeatherApi {
    private let apiKey = "b6dd3cedb673897c7f68486a9b40b7a3"
    // Get weather data from service
    func fetchWeather(latitude:(Double),
                      longitude:(Double),
                      succeed:@escaping (WeatherResponse) -> Void,
                      failed:@escaping (ErrorMessage) -> Void) {

            BaseAPI.shared.request(methotType: .get,
                                   baseURL: Keeper.shared.currentEnvironment.domainUrl,
                                   endPoint: Endpoints.weather.replaceParamsWithCurlyBrackets(String(latitude), String(longitude), apiKey),
                                   params: nil) { (response: WeatherResponse) in
                succeed(response)
            } failed: { (errorMessage: ErrorMessage) in
                failed(errorMessage)
            }
    }
}
