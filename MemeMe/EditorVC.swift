//
//  ViewController.swift
//  MemeMe
//
//  Created by inailuy on 2/24/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import UIKit

class EditorVC: BaseVC, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var bottomFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomFrame = bottomTextfield.frame
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            cameraButton.enabled = false
        }
        
        if selectedMeme != nil {
            imageView.image = selectedMeme.originalImage
            topTextfield.text = selectedMeme.topText
            bottomTextfield.text = selectedMeme.bottomText
        }
        
        drawTextInRect(topTextfield)
        drawTextInRect(bottomTextfield)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardInitialization(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardInitialization(false)
    }
    //MARK: Keyboard Methods
    func keyboardInitialization(start : Bool) {
        let center = NSNotificationCenter.defaultCenter()
        if start == true {
            center.addObserver(self,selector:#selector(EditorVC.keyboardDidShow(_:)),name:UIKeyboardDidShowNotification, object: nil)
            center.addObserver(self,selector:#selector(EditorVC.keyboardWillHide(_:)),name:UIKeyboardWillHideNotification, object: nil)
        } else {
            center.removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
            center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        }
     }
    
    func keyboardDidShow(notification: NSNotification) {
        if bottomTextfield.isFirstResponder() == true {
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.bottomTextfield.frame = self.topTextfield.frame
                self.topTextfield.hidden = true
                }, completion:nil
            )
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextfield.isFirstResponder() == true {
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.bottomTextfield.frame = self.bottomFrame
                self.topTextfield.hidden = false
                }, completion: nil
            )
        }
    }
    //MARK: TextField Methods
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
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        view.endEditing(true)
        
        if (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count > 0 {
            self.dismissViewControllerAnimated(true, completion: {})
        }
    }
    
    @IBAction func barButtonPressed(sender: UIBarButtonItem) {
        if cameraButton == sender {
           imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func shareButtonPressed(sender: UIBarButtonItem) {
        if imageView.image == nil {
            return
        }
        view.endEditing(true)
        
        // Taking a screenshot of the imageView
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, true, 0.0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // Cropping image
        image = resizeImage(image, imageView: imageView)
        selectedMeme = MemeModel(topText:topTextfield.text!, bottomText:bottomTextfield.text!, originalImage:imageView.image!, memeImage: image)
        
        let activityView = UIActivityViewController(activityItems:[selectedMeme.memeImage], applicationActivities: nil)
        activityView.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeMail]
        presentationController?.dismissalTransitionDidEnd(false)
        activityView.completionWithItemsHandler = { activity, success, items, error in
            if success {
                UIImageWriteToSavedPhotosAlbum(self.selectedMeme.memeImage, self, nil, nil)
                (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(self.selectedMeme)
                self.dismissViewControllerAnimated(true, completion: {})
            }
        }
        presentViewController(activityView, animated: true, completion:nil)
    }
    //MARK: UIImagePickerController
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = pickedImage
            imageView.hidden = false
            imageView.frame = view.frame
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: Misc
    func resizeImage(oldImage: UIImage, imageView: UIImageView) -> UIImage {
        var newImage = oldImage
        
        let itemSize = CGSizeMake(imageView.frame.width, imageView.frame.height)
        UIGraphicsBeginImageContext(itemSize)
        let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
        let y = imageView.frame.origin.y + Swift.min(statusBarSize.width, statusBarSize.height)
        
        let imageRect = CGRectMake(0.0, -y, itemSize.width, itemSize.height + y)
        oldImage.drawInRect(imageRect)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func drawTextInRect(textField: UITextField) {
        let attributeDictionary = [NSStrokeWidthAttributeName: -4.0, NSStrokeColorAttributeName : UIColor.blackColor(), NSForegroundColorAttributeName : UIColor.whiteColor()]
        textField.attributedText = NSAttributedString(string: (textField.text)!, attributes: attributeDictionary)
    }
}

