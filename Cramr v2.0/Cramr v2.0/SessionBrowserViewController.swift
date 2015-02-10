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
    
    var courseName: String? {
        didSet {
            // Update the view.
            //            self.configureView()
        }
    }
    
    func addSession(location: String, description: String) {
    
        var curr_user = currentUserInfo.userID
        if curr_user != "" {
            var session = PFObject(className: "Sessions")
            session["active_users"] = [curr_user]
            session["description"] = description
            session["location"] = location
            session["course"] = self.courseName
            session["start_time"] = NSDate()
            session.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
                if (success) {
                    // YAAY
                }
            }
        }
    }
    
    @IBAction func newSesh(sender: AnyObject) {
        let alert = UIAlertController(title: "New session", message: "Fill out all fields to make a new session!", preferredStyle: .Alert)


        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
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
            }
        }
        
        
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        
        
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sessionSwiper" {
            (segue.destinationViewController as SessionViewController).detailItem = self.courseName
        }
    }

}