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
    
//    var delegate:SessionBrowserViewControllerDelegate! = nil
    
    var new_session: PFObject!
    
    var courseName: String? {
        didSet {
            // Update the view.
            //            self.configureView()
        }
    }
    
    @IBAction func popToLockedClass(segue:UIStoryboardSegue) {
        self.performSegueWithIdentifier("lockSessionView", sender: self)
    }
    
    func addSession(location: String, description: String) {
    
        var curr_user = localData.getUserID()
        if curr_user != "" {
            new_session = PFObject(className: "Sessions")
            new_session["active_users"] = [curr_user]
            new_session["description"] = description
            new_session["location"] = location
            new_session["course"] = self.courseName
            new_session["start_time"] = NSDate()
            new_session.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
                if (success) {
                    localData.setSession(self.new_session.objectId)
                }
            }
        }

    }
    
    @IBAction func newSesh(sender: AnyObject) {
        let alert = UIAlertController(title: "New session", message: "Fill out all fields to make a new session!", preferredStyle: .Alert)


        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            if self.sessions.count == 0 {
                self.performSegueWithIdentifier("unwindBack", sender: self)

            }
            // DO STUFF
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
                self.performSegueWithIdentifier("lockSessionView", sender: self)
            }
        }
        
        
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    @IBOutlet weak var createButton: UIButton!
    
    var sessions: [PFObject] = []
    
    func getSessions() {
        var sessionQuery = PFQuery(className: "Sessions")
        self.sessions = [PFObject]()
        sessionQuery.whereKey("course", equalTo: self.courseName)
        var sessionArray = sessionQuery.findObjects()
        for session in sessionArray {
            self.sessions.append(session as PFObject)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSessions()
        
        if sessions.count == 0 {
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
            self.getSessions()
            var destController = segue.destinationViewController as SessionViewController
//            destController.delegate = self
            destController.detailItem = self.courseName
            destController.sessions = self.sessions
        } else if segue.identifier == "lockSessionView" {
            (segue.destinationViewController as SessionLockedViewController).session = self.new_session
        }
    }

}