//
//  ViewController.swift
//  MyMemeMe
//
//  Created by Matthew Waller on 1/18/16.
//  Copyright © 2016 Matthew Waller. All rights reserved.
//

import UIKit

class MakeMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var memeToBeEdited: Meme!
    
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -1.0
        ]
        
        topTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        bottomTextField.delegate = self
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .Center
        
       
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        if memeToBeEdited != nil {
            
            imageView.image = memeToBeEdited.originalImage
            topTextField.text = memeToBeEdited.topString
            bottomTextField.text = memeToBeEdited.bottomString
            
        }
        
        if imageView.image != nil {
            shareButton.enabled = true
        } else {
            shareButton.enabled = false
        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    
    @IBAction func pickImage(sender: AnyObject) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)

    }
    
    @IBAction func takePic(sender: UIBarButtonItem) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageView.image = image
                shareButton.enabled = true
            }

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        view.frame.origin.y -= getKeyboardHeight(notification)
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
 
        view.frame.origin.y += getKeyboardHeight(notification)
    
    }

    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        if bottomTextField.editing != true {
            
            return 0 //this is so that the view doesn't go up when editing the top textfield
        }
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
  
    
    func subscribeToKeyboardNotifications(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func shareAction(sender: UIBarButtonItem) {
        
        let sharingImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [sharingImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            self.save(sharingImage)
        } // completion handler code sample from http://stackoverflow.com/questions/27454467/uiactivityviewcontroller-uiactivityviewcontrollercompletionwithitemshandler
        presentViewController(activityController, animated: true, completion: nil)
        
    }
    
    
    func generateMemedImage() -> UIImage
    {
        navBar.hidden = true
        toolBar.hidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        
        if topTextField.text?.isEmpty == true {
            topTextField.text = "Top"
        }
        
        if bottomTextField.text?.isEmpty == true {
            bottomTextField.text = "Bottom"
        }
        
        let meme = Meme(topString: topTextField.text!, bottomString: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

