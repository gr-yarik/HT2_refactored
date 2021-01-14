//
//  DetailsViewController.swift
//  PM HT2
//
//  Created by Yaroslav Hrytsun on 17.12.2020.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var text: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = text
    }
}
