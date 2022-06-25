/*
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ResponseData : Codable {
    let temperature : Double?
    let windSpeed : Double?
    let humidity : Double?
    let windBearing : Int?
    let cloudCover : Double?
    let time : Int?
    let dewPoint : Double?
    let uvIndex : Int?
    let summary : String?
    let icon : String?
    let precipIntensity : Double?
    let windGust : Double?
    let visibility : Double?
    let apparentTemperature : Double?
    let pressure : Double?
    let precipProbability : Double?
    let ozone : Double?

    enum CodingKeys: String, CodingKey {

        case temperature = "temperature"
        case windSpeed = "windSpeed"
        case humidity = "humidity"
        case windBearing = "windBearing"
        case cloudCover = "cloudCover"
        case time = "time"
        case dewPoint = "dewPoint"
        case uvIndex = "uvIndex"
        case summary = "summary"
        case icon = "icon"
        case precipIntensity = "precipIntensity"
        case windGust = "windGust"
        case visibility = "visibility"
        case apparentTemperature = "apparentTemperature"
        case pressure = "pressure"
        case precipProbability = "precipProbability"
        case ozone = "ozone"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        temperature = try values.decodeIfPresent(Double.self, forKey: .temperature)
        windSpeed = try values.decodeIfPresent(Double.self, forKey: .windSpeed)
        humidity = try values.decodeIfPresent(Double.self, forKey: .humidity)
        windBearing = try values.decodeIfPresent(Int.self, forKey: .windBearing)
        cloudCover = try values.decodeIfPresent(Double.self, forKey: .cloudCover)
        time = try values.decodeIfPresent(Int.self, forKey: .time)
        dewPoint = try values.decodeIfPresent(Double.self, forKey: .dewPoint)
        uvIndex = try values.decodeIfPresent(Int.self, forKey: .uvIndex)
        summary = try values.decodeIfPresent(String.self, forKey: .summary)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        precipIntensity = try values.decodeIfPresent(Double.self, forKey: .precipIntensity)
        windGust = try values.decodeIfPresent(Double.self, forKey: .windGust)
        visibility = try values.decodeIfPresent(Double.self, forKey: .visibility)
        apparentTemperature = try values.decodeIfPresent(Double.self, forKey: .apparentTemperature)
        pressure = try values.decodeIfPresent(Double.self, forKey: .pressure)
        precipProbability = try values.decodeIfPresent(Double.self, forKey: .precipProbability)
        ozone = try values.decodeIfPresent(Double.self, forKey: .ozone)
    }

}
