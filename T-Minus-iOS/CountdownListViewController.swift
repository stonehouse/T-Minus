//
//  CountdownListViewController.swift
//  T-Minus
//
//  Created by Alexander Stonehouse on 20/03/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

import UIKit

class CountdownListViewController: UICollectionViewController {

    override func viewDidLoad() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createCountdown))
    }
    
    func createCountdown() {
        self.performSegue(withIdentifier: "createCountdown", sender: self)
    }
}
