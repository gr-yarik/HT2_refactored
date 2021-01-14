//
//  LoginTableViewController.swift
//  PM HT2
//
//  Created by Yaroslav Hrytsun on 16.12.2020.
//

import UIKit

class LoginTableViewController: UITableViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBarButtonItem: UIBarButtonItem!
    
    var authorizationManager: AuthorizationManagerProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.authorizationManager = AuthorizationManager()
        loginBarButtonItem.isEnabled = false
        createDismissKeyboardTapGesture()
        usernameTextField.becomeFirstResponder()
    }

    
    @IBAction func textFieldsChanged(_ sender: UITextField) {
        if usernameTextField.text == "" || passwordTextField.text == "" {
            loginBarButtonItem.isEnabled = false
        } else {
            loginBarButtonItem.isEnabled = true
        }
    }
   
    
    @IBAction func loginBarButtonItemPressed(_ sender: UIBarButtonItem) {
        authorizationManager.logInRequestToStorage(username: usernameTextField.text!, password: passwordTextField.text!) { result in
            switch result {
            case .failure(let error):
                presentAlertOnMainThread(message: error.rawValue)
            case .success(_):
                performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            let destinationVC = (segue.destination as! UINavigationController).topViewController as! MainMenuTableViewController
            destinationVC.username = usernameTextField.text!
            destinationVC.authorizationManager = authorizationManager
        }
    }
}
