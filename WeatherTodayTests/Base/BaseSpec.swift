//
//  BaseSpec.swift
//  WeatherTodayTests
//
//  Created by alaattib on 27.07.2023.
//

@testable import MyDenizbankNew
import Quick
import Nimble

class BaseSpec: QuickSpec {
    override func setUp() {
        AsyncDefaults.timeout = .seconds(10)
        SessionKeeper.shared.useMockData = true
        setLanguageResources()
    }

    private func setLanguageResources() {
        StubFileManager.loadStub(filename: StubFileName.getToken,
                                 succeed: parseStubFile,
                                 failed: handleFailure)

        func parseStubFile(_ response: TokenResponse) {
            SessionKeeper.shared.languageDictForTest = response.locale.data
        }

        func handleFailure(_: ErrorMessage) {
            // Intentionally unimplemented
        }
    }
}
