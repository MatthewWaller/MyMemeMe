//
//  DetailViewController.swift
//  MyMemeMe
//
//  Created by Matthew Waller on 1/29/16.
//  Copyright © 2016 Matthew Waller. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        imageView.image = meme.memedImage
        navigationController!.navigationBar.topItem!.title = "" //this is to remove the word "Back" in the navigation controller bar and show just the arrow
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let makeMemeViewController = segue.destinationViewController as! MakeMemeViewController
        makeMemeViewController.memeToBeEdited = meme
        
    }
    
}