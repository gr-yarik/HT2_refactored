//
//  AuthorizationManager.swift
//  PM HT2
//
//  Created by Yaroslav Hrytsun on 05.01.2021.
//

import Foundation

protocol AuthorizationManagerProtocol {
    func logInRequestToStorage(username: String, password: String, completionHandler: (Result<User, PMError>) -> ())
    
    func logOut()
    
    func registerNewUserRequestToStorage(status: UserStatus, username: String, password: String, completionHandler: (PMError?) -> ())
    
    var currentInteractedUser: User? { get }
    
    func getAllUsernames(completionHandler: (Result<String, PMError>) -> ())
    
    func banUser(by username: String, completion: (PMError?) -> ())
    
    func saveInteractedUserChanges(changedUser: User) throws
}

class AuthorizationManager: AuthorizationManagerProtocol {
    
    private (set) var currentInteractedUser: User?
    
    var currentInteractedUserStatus: UserStatus? {
        currentInteractedUser?.status
    }
    
    private var persistenceManager: PersistenceManagerProtocol
    
    init(persistenceManager: PersistenceManagerProtocol = PersistenceManager.shared) {
        self.persistenceManager = persistenceManager
    }
    
    
    func logInRequestToStorage(username: String, password: String, completionHandler: (Result<User, PMError>) -> ())  {
        persistenceManager.logIn(with: username, password: password) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let user):
                currentInteractedUser = user
                completionHandler(.success(user))
            }
        }
    }
    
    
    func logOut() {
        currentInteractedUser = nil
    }
    
    
    func registerNewUserRequestToStorage(status: UserStatus, username: String, password: String, completionHandler: (PMError?) -> ()) {
        persistenceManager.registerNewUser(status: status, username: username, password: password, completionHandler: completionHandler)
    }
    
    
    func getAllUsernames(completionHandler: (Result<String, PMError>) -> ()) {
        persistenceManager.getAllUsernames(completionHandler: completionHandler)
    }
    
    
    func banUser(by username: String, completion: (PMError?) -> ()) {
        persistenceManager.getUserByUsername(username: username) { user in
            guard var user = user else {
                completion(.cannotBan)
                return
            }
            user.banStatus = .banned
            self.persistenceManager.updateUserData(with: user)
            completion(nil)
        }
    }
    
    
    func saveInteractedUserChanges(changedUser: User) throws {
        guard let currentUser = currentInteractedUser, currentUser.username == changedUser.username else {
            throw PMError.actionWhenLoggedOut
        }
        persistenceManager.updateUserData(with: changedUser)
    }
}
