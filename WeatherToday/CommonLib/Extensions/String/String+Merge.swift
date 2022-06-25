//
//  String+Merge.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 8.06.2022.
//

import Foundation

public extension Character {
    func merge(_ rhs: String) -> String {
        return "\(self)\(rhs)"
    }

    func merge(_ rhs: Character) -> String {
        return "\(self)\(rhs)"
    }
}

public extension String {
    func merge(_ rhs: Character) -> String {
        return "\(self)\(rhs)"
    }

    func merge(_ rhs: String) -> String {
        return "\(self)\(rhs)"
    }
}

