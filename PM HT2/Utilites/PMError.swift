//
//  PMError.swift
//  PM HT2
//
//  Created by Yaroslav Hrytsun on 17.12.2020.
//

import Foundation

enum PMError: String, Error {
    case busyUsername           = "This username is busy. Try again with another username."
    
    case adminBets              = "According to the task, admins aren't allowed to bet."
    
    case successiveLogin        = "You are already logged in. You need to log out first."
    
    case wrongLoginData         = "Error while logging in. Double-check your login and password."
    
    case loginWhenBanned        = "Error while logging in. You are banned."
    
    case successiveLogout       = "You are already logged out. You need to log in first."
    
    case actionWhenLoggedOut    = "You must log in to perform this action."
    
    case seeBetsWhenLoggedOut   = "You must log in to see placed bets."
    
    case accessDenied           = "The action is allowed only for admins"
    
    case cannotBan              = "This user cannot be banned. They are either non-existant or an admin."
    
    case unknownError           = "Unknown error"
}
