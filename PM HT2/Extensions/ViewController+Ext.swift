//
//  ViewController+Ext.swift
//  PM HT2
//
//  Created by Yaroslav Hrytsun on 16.12.2020.
//

import UIKit

extension UITableViewController {
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
    func presentAlertOnMainThread(title: String = "Error", message: String) {
        DispatchQueue.main.async {
            let infoAlertController     = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let actionButton            = UIAlertAction(title: "OK", style: .default, handler: nil)
            infoAlertController.addAction(actionButton)
            self.present(infoAlertController, animated: true, completion: nil)
        }
    }
    
    
    func presentInputAlertOnMainThread(title: String, completionHandler: @escaping ((String) throws -> Void)) {
        DispatchQueue.main.async {
            let inputAlertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            inputAlertController.addTextField(configurationHandler: nil)
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let actionButton = UIAlertAction(title: "OK", style: .default, handler: { _ in
                do {
                    try completionHandler(inputAlertController.textFields![0].text!)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            })
            inputAlertController.addAction(cancelButton)
            inputAlertController.addAction(actionButton)
            self.present(inputAlertController, animated: true, completion: nil)
        }
    }
}
