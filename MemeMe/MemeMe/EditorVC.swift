//
//  ViewController.swift
//  MemeMe
//
//  Created by inailuy on 2/24/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import UIKit
import QuartzCore

class EditorVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    var bottomFrame: CGRect!
    var isEditingBottomFrame :Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bottomFrame = bottomTextfield.frame
        isEditingBottomFrame = false
        
        self.drawTextInRect(topTextfield)
        self.drawTextInRect(bottomTextfield)
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
    
    
    func replaceTextFieldFrames(){
        let frame = bottomTextfield.frame
        bottomTextfield.frame = topTextfield.frame
        topTextfield.frame = frame
    }
    
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

    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == bottomTextfield {
            isEditingBottomFrame = true
        }else {
            isEditingBottomFrame = false
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
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
    
    func drawTextInRect(textField: UITextField) {
        let attributeDictionary = [NSStrokeWidthAttributeName: -4.0, NSStrokeColorAttributeName : UIColor.blackColor(), NSForegroundColorAttributeName : UIColor.whiteColor()]
        textField.attributedText = NSAttributedString(string: (textField.text)!, attributes: attributeDictionary)
    }
}

