//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Timothy Savard on 9/12/16.
//  Copyright © 2016 Savard, Tim. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memeData: MemeData.Data = MemeData.data

    
    // MARK:- Table View Controller Methods
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear called")
        
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memeData.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Get a fresh cell
        let cellIdentifier: String = "MemeListCell"
        let cell: MemeTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as! MemeTableViewCell
        
        // Decorate & return the cell
        let meme: Meme = memeData.memes[indexPath.row]
        cell.memeImageView.image = meme.compiledImage
        cell.topLabel.text = meme.topText
        cell.bottomLabel.text = meme.bottomText
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
}
