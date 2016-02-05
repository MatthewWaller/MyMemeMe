//
//  TableViewController.swift
//  MyMemeMe
//
//  Created by Matthew Waller on 1/29/16.
//  Copyright © 2016 Matthew Waller. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func returnHome(segue: UIStoryboardSegue) {
        //I added this so that I could return even after making a modal segue from the detail view controller
        //Otherwise, dismissing the viewController alone takes me back to the detail view and not a sent memes page
        //the console reads "Unbalanced calls to begin/end appearance transitions for ..." this seems to be a bug from Apple:  http://stackoverflow.com/questions/32042206/unwind-segue-from-modal-popover-resulting-in-unbalanced-calls-to-begin-end-appea
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView!.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as UITableViewCell
        
        let cellMeme = memes[indexPath.row]
        
        cell.imageView?.image = cellMeme.memedImage
        cell.textLabel?.text = cellMeme.topString
        cell.detailTextLabel?.text = cellMeme.bottomString
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! DetailViewController
        
        let meme = memes[indexPath.item]
        
        detailViewController.meme = meme
        
        navigationController!.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            //answer taken in part from https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson9.html
            
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
}