//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Savard, Tim on 8/4/16.
//  Copyright © 2016 Savard, Tim. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    // Meme Components
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    
    // Chrome
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let picker:UIImagePickerController = UIImagePickerController()
    
    var memeData: MemeData.Data = MemeData.data
    
    
    // MARK:- View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        // Prep UI
        reset()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subcribeToKeyboardNotifications()
        
        // Enable camera button iff camera is accessible
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
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
        textField.attributedText = makeTextMemeWorthy(textField.text!)
        moveDownForKeyboard()
        return true
    }
    
    func keyboardWillHide(notification: NSNotification) {
        moveDownForKeyboard()
    }
    
    func keyboardWillChange(notification: NSNotification) {
        // Only move the keyboard for the bottom text field, as the top is always visible.
        if (bottomTextfield.editing) {
            let height: CGFloat = getKeyboardHeight(notification)
            moveUpForKeyboard(height)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // Uppercase text, but don't supress a new line character (AKA the Done button).
        if (string == "\n") {
            return true
        } else {
            textField.text = (textField.text! as NSString).stringByReplacingCharactersInRange(
                range,
                withString: string.uppercaseString)
            return false
        }
    }
    
    
    // MARK:- UI Methods
    
    @IBAction func endEditing(sender: UITextField) {
        print("endEditing IBAction called")
        view.endEditing(false)
    }
    
    @IBAction func close(sender: UIBarButtonItem) {
        print("close IBAction called")
        self.dismissViewControllerAnimated(true, completion: nil)
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
        topTextfield.attributedText = makeTextMemeWorthy("top");
        bottomTextfield.attributedText = makeTextMemeWorthy("bottom");
    }
    
    func subcribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIKeyboardWillHideNotification,
            object: nil)

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(keyboardWillChange(_:)),
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
    }
    
    func unsubcribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: UIKeyboardWillHideNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardFrame: NSValue = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardFrame.CGRectValue().height
    }
    
    func moveUpForKeyboard(height: CGFloat) {
        view.frame.origin.y = -height
    }
    
    func moveDownForKeyboard() {
        view.frame.origin.y = 0
    }
    
    func makeTextMemeWorthy(string: String) -> NSAttributedString {
        return NSAttributedString(
            string: string.uppercaseString,
            attributes: [
                NSStrokeColorAttributeName : UIColor.blackColor(),
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSStrokeWidthAttributeName : NSNumber(float: -4.0),
                NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
            ]
        )
    }
    
    func buildMemeImage() -> UIImage {
        // Moving everything out of the way
        toolBar.hidden = true
        
        // Say cheese...
        UIGraphicsBeginImageContext(view.frame.size)
        
        // CHEESE
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let compiledImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // And I'm spent
        UIGraphicsEndImageContext()
        
        // Like we were never here
        toolBar.hidden = false
        return compiledImage
    }
    
    func saveMeme(activityType: String?, completed: Bool, returnedItems: [AnyObject]?, activityError: NSError?) {
        if (completed) {
            // Save the meme to the collection
            let meme: Meme = Meme(
                topText: topTextfield.text!,
                bottomText: bottomTextfield.text!,
                originalImage: imageView.image!,
                compiledImage: buildMemeImage())
            
            memeData.memes.append(meme)
            
            // Close the meme view
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

}

