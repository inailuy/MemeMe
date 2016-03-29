//
//  DetailVC.swift
//  MemeMe
//
//  Created by inailuy on 3/26/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import UIKit

class DetailVC: BaseVC {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = selectedMeme.memeImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier(editSegue, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == editSegue {
            let vc = segue.destinationViewController as! EditorVC
            vc.selectedMeme = selectedMeme
        }
    }
}