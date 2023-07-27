//
//  UABuilder.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import UIKit

class UABuilder {
    class func darwinVersion() -> String {
        var sysinfo = utsname()
        uname(&sysinfo)
        guard let dString = String(bytes: Data(bytes: &sysinfo.release,
                                               count: Int(_SYS_NAMELEN)),
                                   encoding: .ascii) else { return "" }
        let dValue = dString.trimmingCharacters(in: .controlCharacters)
        return "Darwin/\(dValue)"
    }

    class func cfNetworkVersion() -> String {
        guard let dictionary = Bundle(identifier: "com.apple.CFNetwork")?.infoDictionary else { return "" }
        let version = dictionary["CFBundleShortVersionString"] as? String
        return "CFNetwork/\(version ?? "")"
    }

    class func deviceVersion() -> String {
        let currentDevice = UIDevice.current
        return "\(currentDevice.systemName)/\(currentDevice.systemVersion)"
    }

    class func deviceName() -> String {
        var sysinfo = utsname()
        uname(&sysinfo)
        guard let dString = String(bytes: Data(bytes: &sysinfo.machine,
                                               count: Int(_SYS_NAMELEN)),
                                   encoding: .ascii) else { return "" }
        return dString.trimmingCharacters(in: .controlCharacters)
    }

    class func appNameAndVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String,
              let name = dictionary["CFBundleName"] as? String else { return "" }
        return "\(name)/\(version)"
    }

    class func uaString() -> String {
        return "\(appNameAndVersion()) \(deviceName()) \(deviceVersion()) \(cfNetworkVersion()) \(darwinVersion())"
    }
}
