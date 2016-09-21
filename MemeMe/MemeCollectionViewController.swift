//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Savard, Tim on 9/21/16.
//  Copyright © 2016 Savard, Tim. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {

    var memeData: MemeData.Data = MemeData.data
    
    
    // MARK:- Collection View Controller Methods
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear called")
        
        self.collectionView!.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memeData.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Get a fresh cell
        let cellIdentifier: String = "MemeCollectionCell"
        let cell: MemeCollectionViewCell =
            collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        
        // Decorate & return the cell
        let meme: Meme = memeData.memes[indexPath.row]
        cell.memeImageView.image = meme.compiledImage
        
        return cell
    }

}
