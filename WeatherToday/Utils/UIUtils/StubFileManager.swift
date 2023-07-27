//
//  StubFileManager.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import Foundation

class StubFileManager {
    static func loadStub<S: Codable, F: Codable>(filename fileName: String,
                                                 succeed: ((S) -> Void)?,
                                                 failed: ((F) -> Void)?) {
        let responseStatus = fileName.split(separator: "#").first
        let isResponseSuccess = responseStatus == "200"
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                if isResponseSuccess {
                    let jsonData = try decoder.decode(S.self, from: data)
                    succeed?(jsonData)
                } else {
                    let jsonData = try decoder.decode(F.self, from: data)
                    failed?(jsonData)
                }
                print("\(fileName) stub file loaded")
            } catch {
                print("error:\(error)")
            }
        } else {
            print("Stub file not found")
        }
    }
}
