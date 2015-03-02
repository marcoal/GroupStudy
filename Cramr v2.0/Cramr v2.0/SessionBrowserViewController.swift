//
//  SessionBrowserViewController.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 2/4/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import UIKit



class SessionBrowserViewController : UIViewController {
    
    var sessions: [[String: String]]?
    
    var courseName: String? {
        didSet {
            // Update the view.
            //            self.configureView()
        }
    }
    
    @IBOutlet weak var createButton: UIButton!
    
    
    
//    @IBAction func popToLockedClass(segue:UIStoryboardSegue) {
//        self.performSegueWithIdentifier("lockSessionView", sender: self)
//    }
    

    
    @IBAction func newSesh(sender: AnyObject) {
        self.performSegueWithIdentifier("createSessionView", sender: self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if sessions?.count == 0 {
            self.newSesh(0)
            self.createButton.hidden = true
            
        }
        
        self.view.backgroundColor = .lightGrayColor()
        self.title = getCourseID(self.courseName!)
        self.navigationItem.leftBarButtonItem?.tintColor = cramrBlue
        self.navigationItem.backBarButtonItem?.tintColor = cramrBlue
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = cramrBlue
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sessionSwiper" {
            var destController = segue.destinationViewController as SessionViewController
            destController.sessions = self.sessions!
        } else if segue.identifier == "createSessionView" {
            (segue.destinationViewController as SessionCreationViewController).courseName = self.courseName
        }
    }

}