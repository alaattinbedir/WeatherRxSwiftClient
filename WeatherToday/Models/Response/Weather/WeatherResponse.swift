//
//  WeatherResponse.swift
//  WeatherSwiftUI
//
//  Created by alaattib on 1.11.2023.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let current: Current?
    let hourly: [Current]?
    let daily: [Daily]?
    let weather : WeatherModel

    enum CodingKeys: String, CodingKey {
        case current, hourly, daily
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        daily = try values.decodeIfPresent([Daily].self, forKey: .daily)
        current = try values.decodeIfPresent(Current.self, forKey: .current)
        hourly = try values.decodeIfPresent([Current].self, forKey: .hourly)

        weather = WeatherModel (weatherType: current?.weather[0].description.rawValue.uppercased() ?? "",
                                currentCityTemp: current?.temp ?? 0,
                                currentDate: current?.dt ?? 0,
                                responseDailyList: daily ?? [],
                                responseHourlyList: hourly ?? [])
    }
}

// MARK: - Current
struct Current: Codable {
    let dt: Int
    let temp: Double
    let humidity: Int
    let sunrise, sunset: Int?
    let uvi: Double
    let windDeg: Int
    let weather: [Weather]
    let feelsLike: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let pressure: Int
    let dewPoint: Double
    let windGust, pop: Double?
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, temp, humidity, sunrise, sunset, uvi
        case windDeg = "wind_deg"
        case weather
        case feelsLike = "feels_like"
        case clouds, visibility
        case windSpeed = "wind_speed"
        case pressure
        case dewPoint = "dew_point"
        case windGust = "wind_gust"
        case pop, rain
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: Main
    let icon: String
    let description: Description
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case moderateRain = "moderate rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
}

enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Daily
struct Daily: Codable {
    let pop: Double
    let rain: Double?
    let dt: Int
    let temp: Temp
    let humidity, sunrise, sunset: Int
    let uvi, moonPhase: Double
    let windDeg: Int
    let windGust: Double
    let moonset: Int
    let feelsLike: FeelsLike
    let weather: [Weather]
    let windSpeed: Double
    let pressure, moonrise: Int
    let dewPoint: Double
    let clouds: Int

    enum CodingKeys: String, CodingKey {
        case pop, rain, dt, temp, humidity, sunrise, sunset, uvi
        case moonPhase = "moon_phase"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case moonset
        case feelsLike = "feels_like"
        case weather
        case windSpeed = "wind_speed"
        case pressure, moonrise
        case dewPoint = "dew_point"
        case clouds
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let night, eve, day, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let night, min, eve, day: Double
    let max, morn: Double
}
