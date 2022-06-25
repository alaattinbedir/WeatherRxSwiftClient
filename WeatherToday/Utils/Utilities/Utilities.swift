//
//  Utilities.swift
//  PhotoApp
//
//  Created by Alaattin Bedir on 2.03.2019.
//  Copyright © 2019 Alaattin Bedir. All rights reserved.
//

import Foundation
import SystemConfiguration

public final class Utilities {
    
    public class var sharedInstance: Utilities {
        struct Singleton {
            static let instance: Utilities = Utilities()
        }
        return Singleton.instance
    }
    
    private init() {
    }
    
    func getDateWithFormat(date: Double, dateFormat: String) -> String {
        let convertedDate = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: convertedDate)
    }

    func getDayFromDate(date: Double) -> String {
        return getDateWithFormat(date: date, dateFormat: "EEEE")
    }
    
    func getHourFromDate(date: Double) -> String {
        return getDateWithFormat(date: date, dateFormat: "HH")
    }
    
    func getFormatedDate(date: Double) -> String {
        return getDateWithFormat(date: date, dateFormat: "MMM d, yyyy")
    }
    
    func convertFahrenheitToCelsius(fahrenheit: Double) -> Double {
        return (fahrenheit - 32) / 1.8
    }
    
    func convertFahrenheitToCelsius(fahrenheit: Double) -> String {
        let celsiusDegree: Double = convertFahrenheitToCelsius(fahrenheit: fahrenheit)
        
        return "\(Int(celsiusDegree))" + "°"
    }
    
}

