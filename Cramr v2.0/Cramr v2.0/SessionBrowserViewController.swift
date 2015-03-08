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
        }
    }
    
    
    func newSesh() {
        self.performSegueWithIdentifier("createSessionView", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if sessions?.count == 0 {
            self.newSesh()
        }
        
        self.view.backgroundColor = .lightGrayColor()
        self.title = getCourseID(self.courseName!)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "newSesh")
    }
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sessionSwiper" {
            (segue.destinationViewController as SessionViewController).sessions = self.sessions!
        } else if segue.identifier == "createSessionView" {
            (segue.destinationViewController as SessionCreationViewController).courseName = self.courseName
        }
    }
    
}