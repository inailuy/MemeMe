//
//  ViewController.swift
//  MemeMe
//
//  Created by inailuy on 2/24/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import UIKit

class EditorVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var bottomFrame: CGRect!
    var isEditingBottomFrame :Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomFrame = bottomTextfield.frame
        isEditingBottomFrame = false
        
        self.drawTextInRect(topTextfield)
        self.drawTextInRect(bottomTextfield)
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            cameraButton.enabled = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Keyboard stuff.
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    //MARK: Keyboard Methods
    func keyboardWillShow(notification: NSNotification) {
        if isEditingBottomFrame == true {
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.bottomTextfield.frame = self.topTextfield.frame
                self.topTextfield.hidden = true
            }, completion: nil)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if isEditingBottomFrame == true {
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.bottomTextfield.frame = self.bottomFrame
                self.topTextfield.hidden = false
            }, completion: nil)
        }
    }
    //MARK: TextField Methods
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == bottomTextfield {
            isEditingBottomFrame = true
        }else {
            isEditingBottomFrame = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    //MARK: User Interactions
    @IBAction func gestureRecognized(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func cancelBttonPressed(sender: UIBarButtonItem) {
        view.endEditing(true)
    }
    
    @IBAction func cameraButtonPressed(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
   
    @IBAction func albumButtonPressed(sender: UIBarButtonItem) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(sender: UIBarButtonItem) {
        // Taking a screenshot of the imageView
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, true, 0.0);
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        // Cropping image
        image = self.resizeImage(image, imageView: imageView)
        
        let activityView = UIActivityViewController(activityItems:[image], applicationActivities: nil)
        activityView.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMail]
        
        presentationController?.dismissalTransitionDidEnd(false)
        self.presentViewController(activityView, animated: true, completion: nil)
        
        // Saving Image
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    }
    //MARK: UIImagePickerController
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = pickedImage
            imageView.hidden = false
            imageView.frame = view.frame
            imageView.contentMode = UIViewContentMode.ScaleAspectFit;
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: Misc
    func resizeImage(oldImage: UIImage, imageView: UIImageView) -> UIImage {
        var newImage = oldImage
        
        let itemSize = CGSizeMake(imageView.frame.width, imageView.frame.height)
        UIGraphicsBeginImageContext(itemSize);
        let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
        let y = imageView.frame.origin.y + Swift.min(statusBarSize.width, statusBarSize.height)
        
        let imageRect = CGRectMake(0.0, -y, itemSize.width, itemSize.height + y);
        oldImage.drawInRect(imageRect)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return newImage
    }
    
    func drawTextInRect(textField: UITextField) {
        let attributeDictionary = [NSStrokeWidthAttributeName: -4.0, NSStrokeColorAttributeName : UIColor.blackColor(), NSForegroundColorAttributeName : UIColor.whiteColor()]
        textField.attributedText = NSAttributedString(string: (textField.text)!, attributes: attributeDictionary)
    }
    
    func replaceTextFieldFrames(){
        let frame = bottomTextfield.frame
        bottomTextfield.frame = topTextfield.frame
        topTextfield.frame = frame
    }
    
}

