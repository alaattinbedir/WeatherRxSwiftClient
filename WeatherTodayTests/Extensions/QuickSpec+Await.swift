//
//  QuickSpec+Await.swift
//  WeatherTodayTests
//
//  Created by Alaattin Bedir on 2.06.2022.
//

@testable import WeatherToday
import Foundation
import XCTest
import ObjectMapper
import Quick
import Nimble

extension QuickSpec {
    func awaitRequest(wait: TimeInterval = 0.2, _ makeRequest: @autoclosure @escaping () -> Void) {
        waitUntil(timeout: .seconds(10 + Int(wait))) { done in
            makeRequest()
            DispatchQueue.main.asyncAfter(deadline: .now() + wait, execute: done)
        }
    }

    func awaitRequest() {
        awaitRequest( { /*  only wait */ }())
    }

    func awaitUpdate() {
        waitUntil(timeout: .seconds(10)) { done in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                done()
            }
        }
    }
}
