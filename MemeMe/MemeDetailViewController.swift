//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Timothy Savard on 9/22/16.
//  Copyright © 2016 Savard, Tim. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    
    var memeImage: UIImage? = nil
    
    
    // MARK:- View Controller Methods
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        memeImageView!.image = memeImage
    }
    
}
