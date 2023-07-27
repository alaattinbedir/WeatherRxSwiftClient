//
//  OtpRequest.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import Foundation

struct OtpRequest: Codable, RequestBodyConvertible {
    var userName: String = ""
    var email: String = ""
}
