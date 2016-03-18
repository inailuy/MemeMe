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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    var height : CGFloat!
    var contentInsets : UIEdgeInsets!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        height = 0
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func replaceTextFieldFrames(){
        let frame = bottomTextfield.frame
        bottomTextfield.frame = topTextfield.frame
        topTextfield.frame = frame
    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if keyboardSize.height > 0 {
                let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets
                
                var aRect: CGRect = self.view.frame
                aRect.size.height -= keyboardSize.height
                let activeTextFieldRect: CGRect? = bottomTextfield?.frame
                let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
                if (!CGRectContainsPoint(aRect, activeTextFieldOrigin!)) {
                    scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if keyboardSize.height > 0 {
                let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets
            }
        }
    }
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        view.endEditing(true)
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == bottomTextfield {
            scrollView.scrollEnabled = true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == bottomTextfield {
            scrollView.scrollEnabled = true
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    @IBAction func gestureRecognized(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func shareButtonPressed(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func cancelBttonPressed(sender: UIBarButtonItem) {
        view.endEditing(true)
    }
    
    @IBAction func cameraButtonPressed(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func albumButtonPressed(sender: UIBarButtonItem) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = pickedImage
            imageView.hidden = false
            imageView.frame = view.frame
            //imageView.contentMode = .ScaleAspectFit
            print(imageView, imageView.image, imageView.frame)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

