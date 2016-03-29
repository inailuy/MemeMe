//
//  SentMemesTVC.swift
//  MemeMe
//
//  Created by inailuy on 3/26/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import UIKit

class SentMemesTVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSegueWithIdentifier("initualSegue", sender: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier(editSegue, sender: nil)
    }
    //MARK: TableView Delegate/DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(idCell)
        let imageView = cell!.contentView.viewWithTag(100) as! UIImageView
        let label = cell!.contentView.viewWithTag(101) as! UILabel
        
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        imageView.image = meme.memeImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFit;
        label.text = meme.topText + " " + meme.bottomText
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedMeme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        performSegueWithIdentifier(detaiSegue, sender: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == detaiSegue {
            let vc = segue.destinationViewController as! DetailVC
            vc.selectedMeme = selectedMeme
        }
    }
}
