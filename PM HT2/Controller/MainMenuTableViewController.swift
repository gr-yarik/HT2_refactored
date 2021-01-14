//
//  MainMenuTableViewController.swift
//  PM HT2
//
//  Created by Yaroslav Hrytsun on 16.12.2020.
//

import UIKit

class MainMenuTableViewController: UITableViewController {

    var username: String!
    var users: String!
    
    var authorizationManager: AuthorizationManagerProtocol!
    var userInteractionManager: UserInteractionManagerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInteractionManager = UserInteractionManager(authorizationManager: authorizationManager)
        title = username
    }

    
    @IBAction func placeBetButtonPressed(_ sender: UIButton) {
        presentInputAlertOnMainThread(title: "Enter your bet") { [weak self] bet in
            guard let self = self else { return }
            self.userInteractionManager.placeBet(bet: Bet(outcome: bet)) { error in
                if let error = error {
                    self.presentAlertOnMainThread(message: error.rawValue)
                }
            }
        }
    }
    
    
    @IBAction func banUserButtonPressed(_ sender: UIButton) {
        presentInputAlertOnMainThread(title: "Enter user`s username") { [weak self] username in
            guard let self = self else { return }
            self.userInteractionManager.banUser(by: username) { error in
                if let error = error {
                    self.presentAlertOnMainThread(message: error.rawValue)
                }
            }
            
        }
    }
    
    
    @IBAction func browseUsers(_ sender: Any) {
        userInteractionManager.getUsers { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.users = users
                performSegue(withIdentifier: "usersSegue", sender: nil)
            case .failure(let error):
                self.presentAlertOnMainThread(message: error.rawValue)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromMainMenu" {
            authorizationManager.logOut()
        }
        else if segue.identifier == "betsSegue" {
            userInteractionManager.getPlacedBets { result in
                switch result {
                case .success(let placedBets):
                    let destinationVC = (segue.destination as! UINavigationController).topViewController as! DetailsViewController
                    destinationVC.text = placedBets
                case .failure(let error):
                    self.presentAlertOnMainThread(message: error.rawValue)
                }
            }
        }
        else if segue.identifier == "usersSegue" {
            let destinationVC = (segue.destination as! UINavigationController).topViewController as! DetailsViewController
            destinationVC.text = users
        }
    }
    
}
