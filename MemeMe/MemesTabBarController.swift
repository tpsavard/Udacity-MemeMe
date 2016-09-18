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
    
    override func viewWillAppear(animated: Bool) {
        print("MemesTabBarController will appear")
    }
    
    
    // MARK:- UI Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowMemeView") {
            print("ShowMemeView segue called")
            
            // Pass the meme collection to the meme creator view
            let memeViewController: MemeViewController = segue.destinationViewController as! MemeViewController
            memeViewController.memes = memes
        }
    }
    
    
    // MARK:- Other Methods

    func setupTabs() {
        // Pass the meme collection to tab bar views
        let tableViewController: MemeTableViewController = viewControllers![0] as! MemeTableViewController
        tableViewController.memes = memes
    }
}
