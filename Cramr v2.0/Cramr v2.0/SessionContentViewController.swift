//
//  SessionContentViewController.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 2/4/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation

class SessionContentViewController: UIViewController {
    
    var currentSessionID : String?
    
    var curr_session: PFObject!

    @IBAction func joinButton(sender: AnyObject) {
        var findSession = PFQuery(className: "Sessions")
        curr_session = findSession.getObjectWithId(currentSessionID)
        var activeUsers = curr_session["active_users"] as [String]
        activeUsers.append(currentUserInfo.userID)
        curr_session["active_users"] = activeUsers
        curr_session.saveInBackground()
        currentUserInfo.sessionID = currentSessionID!
        self.performSegueWithIdentifier("pushToLockedFromJoin", sender: self)
    }
    
    
    @IBOutlet weak var descript: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    var dataObject: PFObject? {
        didSet {
            
        }
    }
    

    
    @IBOutlet weak var stupidLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stupidLabel.text = (self.dataObject?.objectForKey("course") as String)
        descript.text = (self.dataObject?.objectForKey("description") as String)
        locationLabel.text = (self.dataObject?.objectForKey("location") as String)
        
        descript.numberOfLines = 0
        descript.sizeToFit()
        currentSessionID = self.dataObject?.objectId
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushToLockedFromJoin" {
            (segue.destinationViewController as SessionLockedViewController).session = self.curr_session
        }
    }
    
    
}