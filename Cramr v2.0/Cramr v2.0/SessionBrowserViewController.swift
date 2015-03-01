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

    var newSession: [String: String]!
    
    var sessions: [[String: String]]?
    
    var courseName: String? {
        didSet {
            // Update the view.
            //            self.configureView()
        }
    }
    
    @IBOutlet weak var createButton: UIButton!
    
    
    
    @IBAction func popToLockedClass(segue:UIStoryboardSegue) {
        self.performSegueWithIdentifier("lockSessionView", sender: self)
    }
    
    func addSessionCallback(session: [String: String]) {
        self.newSession = session
        self.performSegueWithIdentifier("lockSessionView", sender: self)
    }
    
    
    func addSession(location: String, description: String) {
        (UIApplication.sharedApplication().delegate as AppDelegate).addSessionAD(localData.getUserID(), courseName: self.courseName!, description: description, location: location, cb: addSessionCallback)
    }
    
    @IBAction func newSesh(sender: AnyObject) {
        let alert = UIAlertController(title: "New session", message: "Fill out all fields to make a new session!", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            if self.sessions?.count == 0 {
                self.performSegueWithIdentifier("unwindBack", sender: self)
            }
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Location"
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Description"
        }
        
        
        let createAction = UIAlertAction(title: "Create", style: .Default) { (action) in
                let locText = alert.textFields![0] as UITextField
                let desText = alert.textFields![1] as UITextField
            
            if locText.text != "" && desText.text != "" {
                self.addSession(locText.text, description: desText.text)
            }
        }
        
        
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)

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
        } else if segue.identifier == "lockSessionView" {
            (segue.destinationViewController as SessionLockedViewController).session = self.newSession
        }
    }

}