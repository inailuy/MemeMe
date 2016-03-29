//
//  SentMemesCVC.swift
//  MemeMe
//
//  Created by inailuy on 3/26/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import UIKit

class SentMemesCVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    @IBAction func addButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier(editSegue, sender: nil)
    }
    //MARK: CollectionView Delegate/DataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(idCell, forIndexPath: indexPath)

        let imageView = cell.contentView.viewWithTag(100) as! UIImageView
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        imageView.image = meme.memeImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedMeme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        performSegueWithIdentifier(detaiSegue, sender: nil)
    }
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == detaiSegue {
            let vc = segue.destinationViewController as! DetailVC
            vc.selectedMeme = selectedMeme
        }
    }
}
