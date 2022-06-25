//
//  Session.swift
//  PhotoApp
//
//  Created by Alaattin Bedir on 2.03.2019.
//  Copyright © 2019 Alaattin Bedir. All rights reserved.
//

class SessionKeeper {
    static let shared = SessionKeeper()

    var loginUserName: String?
}

enum SessionStatus {
    case undefined
    case logined
    case serviceSessionExpire
    case securityError
    case logOffSession
    case appTerminated
    case appBackgroundTimeout
}
