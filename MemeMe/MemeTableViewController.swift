//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Timothy Savard on 9/12/16.
//  Copyright © 2016 Savard, Tim. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] = MemeData.data.memes

    
    // MARK:- Table View Controller Methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Get a fresh cell
        let cellIdentifier: String = "MemeListCell"
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        
        // Decorate & return the cell
        let meme: Meme = memes[indexPath.row]
        cell.imageView?.image = meme.compiledImage
        cell.textLabel?.text = meme.topText + " / " + meme.bottomText
        
        return cell
    }

}
