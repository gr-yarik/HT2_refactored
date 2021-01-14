//
//  PersistenceManager.swift
//  PM HT2
//
//  Created by Yaroslav Hrytsun on 05.01.2021.
//

import Foundation

protocol PersistenceManagerProtocol {
    func registerNewUser(status: UserStatus, username: String, password: String, completionHandler: (PMError?) -> ())
    func logIn(with username: String, password: String, completionHandler: (Result<User, PMError>) -> ())
    func getAllUsernames(completionHandler: (Result<String, PMError>) -> ())
    func getUserByUsername(username: String, completionHandler: (User?) -> ())
    func updateUserData(with updatedUser: User)
}

class PersistenceManager: PersistenceManagerProtocol {
    
    static let shared = PersistenceManager()
    
    private init () { }
    
    private var users: [String : User] = [ : ]
    
    func registerNewUser(status: UserStatus, username: String, password: String, completionHandler: (PMError?) -> ()) {
        guard users[username] == nil else {
            completionHandler(PMError.busyUsername)
            return
        }
        let newUser = User(status: status, username: username, password: password)
        users[username] = newUser
        completionHandler(nil)
    }
    
    
    func logIn(with username: String, password: String, completionHandler: (Result<User, PMError>) -> ()) {
        guard let user = users[username], user.password == password else {
            completionHandler(.failure(.wrongLoginData))
            return
        }
        guard user.banStatus == .notBanned else {
            completionHandler(.failure(.loginWhenBanned))
            return
        }
        completionHandler(.success(user))
    }
    
    
    func getAllUsernames(completionHandler: (Result<String, PMError>) -> ()) {
        var usernames: [String] = []
        for (key, user) in users where user.status == .regular  {
            usernames.append(key)
        }
        completionHandler(.success(usernames.joined(separator: "\n")))
    }
    
    
    func getUserByUsername(username: String, completionHandler: (User?) -> ()) {
        guard let user = users[username] else {
            completionHandler(nil)
            return
        }
        completionHandler(user)
    }
    
    
    
    func updateUserData(with updatedUser: User) {
        users[updatedUser.username] = updatedUser
    }
    
}
