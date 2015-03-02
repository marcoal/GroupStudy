//
//  SessionCreationViewController.swift
//  Cramr v2.0
//
//  Created by Roberto Alvarez on 3/1/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation


class SessionCreationViewController : UIViewController {
    
    var courseName: String?  {
        didSet {
            
        }
    }
    
    var newSession: [String: String]!
    
    @IBOutlet weak var descriptionField: UITextField!
    
    @IBOutlet weak var locationField: UITextField!
    
    @IBAction func createSession(sender: AnyObject) {
        var descriptionText = descriptionField.text
        var locationText = locationField.text
        
        if descriptionText == "" && locationText == "" {
            errorAlert("Please fill in a description and a location!")
        } else if descriptionText == "" {
            errorAlert("Please fill in a description!")
        } else if locationText == "" {
            errorAlert("Please fill in a location!")
        } else {
            addSession(locationText, description: descriptionText)
        }
    }
    
    func errorAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        let closeAction = UIAlertAction(title: "Close", style: .Cancel) { action -> Void in
        }
        alert.addAction(closeAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func addSessionCallback(session: [String: String]) {
        self.newSession = session
        self.performSegueWithIdentifier("lockSessionView", sender: self)
    }
    
    func addSession(location: String, description: String) {
        (UIApplication.sharedApplication().delegate as AppDelegate).addSessionAD(localData.getUserID(), courseName: self.courseName!, description: description, location: location, cb: addSessionCallback)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "lockSessionView" {
            var destController = segue.destinationViewController as SessionLockedViewController
            destController.session = self.newSession
        }
    }
    
    override func viewDidLoad() {
        // It breaks here
        self.view.backgroundColor = .lightGrayColor()
        NSLog("couseName: " + self.courseName!)
        self.title = getCourseID(self.courseName!)
        self.navigationItem.leftBarButtonItem?.tintColor = cramrBlue
        self.navigationItem.backBarButtonItem?.tintColor = cramrBlue
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = cramrBlue
    }

    //    @IBAction func newSesh(sender: AnyObject) {
    //        let alert = UIAlertController(title: "New session", message: "Fill out all fields to make a new session!", preferredStyle: .Alert)
    //
    //        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
    //            if self.sessions?.count == 0 {
    //                self.performSegueWithIdentifier("unwindBack", sender: self)
    //            }
    //        }
    //
    //        alert.addTextFieldWithConfigurationHandler { (textField) in
    //            textField.placeholder = "Location"
    //        }
    //
    //        alert.addTextFieldWithConfigurationHandler { (textField) in
    //            textField.placeholder = "Description"
    //        }
    //
    //
    //        let createAction = UIAlertAction(title: "Create", style: .Default) { (action) in
    //                let locText = alert.textFields![0] as UITextField
    //                let desText = alert.textFields![1] as UITextField
    //
    //            if locText.text != "" && desText.text != "" {
    //                self.addSession(locText.text, description: desText.text)
    //            }
    //        }
    //
    //
    //        alert.addAction(createAction)
    //        alert.addAction(cancelAction)
    //        
    //        self.presentViewController(alert, animated: true, completion: nil)
    //
    //    }
    //    

    
}