//
//  UserInteractionManager.swift
//  PM HT2
//
//  Created by Yaroslav Hrytsun on 11.01.2021.
//

import Foundation

protocol UserInteractionManagerProtocol {
    func placeBet(bet: Bet, completion: (PMError?) -> ())
    func getPlacedBets(completion: (Result<String, PMError>) -> ())
    func getUsers(completion: (Result<String, PMError>) -> ())
    func banUser(by username: String, completion: (PMError?) -> ()) 
}

class UserInteractionManager: UserInteractionManagerProtocol {
    
    var authorizationManager: AuthorizationManagerProtocol
    
    var currentUser: User?
    
    init(authorizationManager: AuthorizationManagerProtocol){
        self.authorizationManager = authorizationManager
        currentUser = authorizationManager.currentInteractedUser
    }
    
    
    func placeBet(bet: Bet, completion: (PMError?) -> ()) {
        switch currentUser?.status {
        case .admin:
            completion(.adminBets)
        case .regular:
            currentUser?.placedBets.append(bet)
        case .none:
            completion(.unknownError)
        }
        
        let error = saveChanges()
        guard error == nil else {
            completion(error)
            return
        }
    }
    
    
    func getPlacedBets(completion: (Result<String, PMError>) -> ()) {
        completion(.success(currentUser!.placedBets.reduce("") { (text, bet) in
                                "\(text) \n \(bet.description)"}))
    }
    
    
    func getUsers(completion: (Result<String, PMError>) -> ()) {
        switch currentUser?.status {
        case .admin:
            authorizationManager.getAllUsernames(completionHandler: completion)
        case .regular:
            completion(.failure(.accessDenied))
        case .none:
            completion(.failure(.accessDenied))
        }
    }
    
    
    func banUser(by username: String, completion: (PMError?) -> ()) {
        switch currentUser?.status {
        case .admin:
            authorizationManager.banUser(by: username) { error in
                guard let error = error else {
                    completion(nil)
                    return
                }
                completion(error)
            }
        default:
            completion(.accessDenied)
        }
    }
    
    
    private func saveChanges() -> PMError? {
        do {
            try authorizationManager.saveInteractedUserChanges(changedUser: currentUser!)
        } catch let error {
            return error as? PMError
        }
        return nil
    }
    
}
