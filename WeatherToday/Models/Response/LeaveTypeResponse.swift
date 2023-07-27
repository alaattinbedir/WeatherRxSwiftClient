//
//  LeaveTypeResponse.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//
import Foundation

struct LeaveTypesResponse: Codable {
    var leaveTypes: [LeaveTypes]?

    enum CodingKeys: String, CodingKey {
        case leaveTypes
    }
}

enum LeaveTypeCodeEnum: String, Codable {
    case annualLeave = "01"
    case excuseLeave = "02"
    case healthReportLeave = "03"
    case maternityLeave = "04"
    case milkLeave = "05"
    case freeLeave = "06"
    case halfTimeLeave = "07"
    case partTimeLeave = "08"
}

struct LeaveTypes: Codable, Equatable {
    var leaveTypeCode: LeaveTypeCodeEnum
    var leaveTypeName: String?
    var maxDayCount: String?
    var parentLeaveTypeCode: String?
    var parentLeaveTypeName: String?
}
