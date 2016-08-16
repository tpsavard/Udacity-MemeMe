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
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let picker:UIImagePickerController = UIImagePickerController()
    let meme:Meme? = nil
    
    
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
        
        // Subscribe to keyboard notifications
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from keybaord notifications
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    
    // MARK:- Delegate Methods, Notification Handlers
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("imagePickerController:didFinishPickingMediaWithInfo called")
        
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        
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
        self.view.endEditing(false)
    }
    
    @IBAction func reset(sender: UIBarButtonItem) {
        print("reset IBAction called")
        reset()
    }
    
    @IBAction func getPhoto(sender: UIBarButtonItem) {
        print("getPhoto IBAction called")
        
        picker.allowsEditing = false
        picker.modalPresentationStyle = .FullScreen
        
        if (sender.tag == cameraButton.tag) {
            picker.sourceType = .Camera
        } else {
            picker.sourceType = .PhotoLibrary
        }
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        print("share IBAction called")
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
    
    func compileMeme() {
        
    }

}

