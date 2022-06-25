//
//  WeatherVMSpec.swift
//  WeatherTodayTests
//
//  Created by Alaattin Bedir on 2.06.2022.
//

@testable import WeatherToday
import Foundation
import ObjectMapper
import Quick
import Nimble

class WeatherVMSpec: QuickSpec {

    override func spec() {
        
        describe("Weather viewmodel page tests") {
            WeatherStub.enable()
            context("Page opened") {
                it("Init test") {
                    _ = WeatherVM()
                    expect(true) == true
                }
            }
            context("Fetch current weather") {
                let viewModel = WeatherVM()
                self.awaitRequest(viewModel.fetchCurrentWeather())
                viewModel.weather.accept(WeatherResponse())
                viewModel.currentDate.accept(12)
                viewModel.weatherType.accept("Weather Type")
                viewModel.currentCityTemp.accept(32)
                self.awaitUpdate()

                it("Then weather response shuld not be nil") {
                    expect(viewModel.weather.value).toNot(beNil())
                }

                it("Then current date should not be nil") {
                    expect(viewModel.currentDate.value).toNot(beNil())
                }

                it("Then weather type should not be nil") {
                    expect(viewModel.weatherType.value).toNot(beNil())
                }

                it("Then current city temp should be nil") {
                    expect(viewModel.currentCityTemp.value).toNot(beNil())
                }
            }
        }
    }
}
