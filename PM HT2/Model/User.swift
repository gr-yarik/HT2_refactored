//
//  BettingSystem.swift
//  PM HT2
//
//  Created by Yaroslav Hrytsun on 16.12.2020.
//

import Foundation


struct User {
    var status: UserStatus
    let username: String
    let password: String
    var placedBets: [Bet] = []
    var banStatus: BanStatus = .notBanned
}

enum UserStatus {
    case regular
    case admin
}

enum LogStatus {
    case loggedIn
    case loggedOut
}

enum BanStatus {
    case banned
    case notBanned
}
