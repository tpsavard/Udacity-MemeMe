//
//  MemeData.swift
//  MemeMe
//
//  Created by Savard, Tim on 9/19/16.
//  Copyright © 2016 Savard, Tim. All rights reserved.
//

import Foundation

// Inspriation for this singleton data store came from the following Stack Overflow question:
// http://stackoverflow.com/questions/29734954/how-do-you-share-data-between-view-controllers-and-other-objects-in-swift

class MemeData {
    
    class Data {
        var memes: [Meme] = []
    }
    
    // Globally accessible, consistent data container
    static let data: Data = Data()
    
}
