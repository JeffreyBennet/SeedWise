//
//  SearchViewController.swift
//  Sustainability
//
//  Created by Jeffrey Bennet on 3/3/23.
//

import Foundation

import Foundation
import UIKit
import FirebaseAuth

class SearchViewController: UIViewController{
    @IBOutlet var welcome: UILabel!
    override func viewDidLoad() {
        DispatchQueue.main.async { [self] in
            self.welcome.text = "Hey " + Constants.name + "!"
        }
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
}
