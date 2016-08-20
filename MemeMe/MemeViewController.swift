//
//  ViewController.swift
//  MemeMe
//
//  Created by Savard, Tim on 8/4/16.
//  Copyright © 2016 Savard, Tim. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    // Meme Components
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    
    // Chrome
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let picker:UIImagePickerController = UIImagePickerController()
    
    var meme:Meme? = nil
    
    
    // MARK:- View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        // Prep UI
        reset()
        
        // Enable camera button iff camera is accessible
        cameraButton.enabled =
            UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subcribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubcribeToKeyboardNotifications()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    // MARK:- Delegate Methods, Notification Handlers
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("imagePickerController:didFinishPickingMediaWithInfo called")
        
        // Set the image
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        
        // Update UI
        shareButton.enabled = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        moveDownForKeybaord()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let height: CGFloat = getKeyboardHeight(notification)
        moveUpForKeybaord(height)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        moveDownForKeybaord()
    }
    
    
    // MARK:- UI Methods
    
    @IBAction func endEditing(sender: UITextField) {
        print("endEditing IBAction called")
        view.endEditing(false)
    }
    
    @IBAction func reset(sender: UIBarButtonItem) {
        print("reset IBAction called")
        reset()
    }
    
    @IBAction func getPhoto(sender: UIBarButtonItem) {
        print("getPhoto IBAction called")
        
        // Common picker settings
        picker.allowsEditing = false
        picker.modalPresentationStyle = .FullScreen
        
        // Choose the camera or album view, depending on what button was pressed
        if (sender.tag == cameraButton.tag) {
            picker.sourceType = .Camera
        } else {
            picker.sourceType = .PhotoLibrary
        }
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        print("share IBAction called")
        
        // Build the meme
        let memeImage: UIImage = buildMemeImage()
        
        // Share the meme
        let activityViewController: UIActivityViewController = UIActivityViewController(
            activityItems: [memeImage],
            applicationActivities: nil)
        activityViewController.completionWithItemsHandler = saveMeme
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    
    // MARK:- Other Methods
    
    func reset() {
        // Reset Meme
        imageView.image = nil
        
        // Reset UI
        shareButton.enabled = false
        topTextfield.text = "TOP"
        bottomTextfield.text = "BOTTOM"
    }
    
    func subcribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    func unsubcribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardFrame: NSValue = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardFrame.CGRectValue().height
    }
    
    func moveUpForKeybaord(height: CGFloat) {
        // Move only if the view hasn't been moved already
        if (view.frame.origin.y == 0) {
            view.frame.origin.y -= height
        }
    }
    
    func moveDownForKeybaord() {
        view.frame.origin.y = 0
    }
    
    func buildMemeImage() -> UIImage {
        // Moving everything out of the way
        toolBar.hidden = true
        
        // Say cheese...
        UIGraphicsBeginImageContext(view.frame.size)
        
        // CHEESE
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let compiledImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // And I'm spent
        UIGraphicsEndImageContext()
        
        // Like we were never here
        toolBar.hidden = false
        return compiledImage
    }
    
    func saveMeme(activityType: String?, completed: Bool, returnedItems: [AnyObject]?, activityError: NSError?) {
        // Saving to an instance variable to convince Xcode we're doing something with the struct
        meme = Meme(
            topText: topTextfield.text!,
            bottomText: bottomTextfield.text!,
            originalImage: imageView.image!,
            compiledImage: buildMemeImage())
    }

}

