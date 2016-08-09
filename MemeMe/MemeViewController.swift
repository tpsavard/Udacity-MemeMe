//
//  ViewController.swift
//  MemeMe
//
//  Created by Savard, Tim on 8/4/16.
//  Copyright © 2016 Savard, Tim. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // Meme Components
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    
    // Chrome
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let picker:UIImagePickerController = UIImagePickerController()
    
    // MARK:- View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        reset()
        
        // Enable camera button iff camera is accessible
        cameraButton.enabled =
            UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    // MARK:- Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("imagePickerController:didFinishPickingMediaWithInfo called")
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel")
    }
    
    // MARK:- UI Methods
    
    @IBAction func reset(sender: UIBarButtonItem) {
        print("reset IBAction called")
    }
    
    @IBAction func getPhotoFromCamera(sender: UIBarButtonItem) {
        print("getPhotoFromCamera IBAction called")
    }
    
    @IBAction func getPhotoFromAlbum(sender: UIBarButtonItem) {
        print("getPhotoFromAlbum IBAction called")
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        print("share IBAction called")
    }
    
    // MARK:-
    
    func reset() {
        // Reset Meme
        imageView.image = nil
        
        // Reset UI
        shareButton.enabled = false
        topTextfield.text = "TOP"
        bottomTextfield.text = "BOTTOM"
    }

}

