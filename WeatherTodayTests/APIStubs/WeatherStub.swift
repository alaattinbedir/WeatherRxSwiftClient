//
//  WeatherStub.swift
//  WeatherTodayTests
//
//  Created by Alaattin Bedir on 2.06.2022.
//

import Foundation
import OHHTTPStubs

class WeatherStub {
    class func enable() {
        stub(condition: isMethodGET() && isPath("https://api.darksky.net/forecast/2bb07c3bece89caf533ac9a5d23d8417/"),
             response: { _ in
                 guard let path = OHPathForFileInBundle("success_weather_response.json", Bundle.main)
                 else {
                     preconditionFailure("Could not find expected file in test bundle")
                 }
                 return fixture(filePath: path, status: 200, headers: ["Content-Type": "application/json"])
             })
    }
}
