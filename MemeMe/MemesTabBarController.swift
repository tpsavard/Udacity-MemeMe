//
//  MemesTabBarController.swift
//  MemeMe
//
//  Created by Timothy Savard on 9/12/16.
//  Copyright © 2016 Savard, Tim. All rights reserved.
//

import UIKit

class MemesTabBarController: UITabBarController {

    var memes: [Meme] = []
    
    
    // MARK:- Tab Bar Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
    }
    
    
    // MARK:- Other Methods

    func setupTabs() {
        // Pass the collection to tab bar views
        let tableViewController: MemeTableViewController = viewControllers![0] as! MemeTableViewController
        tableViewController.memes = memes
    }
}
