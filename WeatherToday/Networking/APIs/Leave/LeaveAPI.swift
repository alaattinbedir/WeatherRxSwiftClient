//
//  LeaveAPI.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import Foundation

class LeaveAPI {
    func getLeaveTypes(succeed: @escaping (LeaveTypesResponse) -> Void,
                       failed: @escaping (ErrorMessage) -> Void) {
        BaseAPI.shared.request(methotType: .post,
                               endPoint: Endpoints.getLeaveTypes,
                               params: nil,
                               lockScreen: true,
                               stubFileName: StubFileName.getLeaveTypes,
                               useMockData: true,
                               succeed: succeed,
                               failed: failed)
    }

    func getLeaveSubTypes(succeed: @escaping (LeaveSubTypesResponse) -> Void,
                          failed: @escaping (ErrorMessage) -> Void) {
        BaseAPI.shared.request(methotType: .post,
                               endPoint: Endpoints.getLeaveSubTypes,
                               params: nil,
                               lockScreen: true,
                               stubFileName: StubFileName.getLeaveSubTypes,
                               useMockData: true,
                               succeed: succeed,
                               failed: failed)
    }
}
