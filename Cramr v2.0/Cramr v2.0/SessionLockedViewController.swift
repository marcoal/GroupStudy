//
//  SessionLockedViewController.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 2/9/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import UIKit

class SessionLockedViewController: UIViewController, FBFriendPickerDelegate {
    
    var friendPickerController: FBFriendPickerViewController!
    
    
    @IBOutlet weak var selectedFriendsView: UITextView!
    
    @IBOutlet weak var className: UILabel!
    
    @IBOutlet weak var desciptLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var currentUsers: UILabel!
    
    var session: PFObject? {
        didSet {
            
        }
    }
    
    
    
    @IBAction func leaveSession(sender: AnyObject) {
        var query = PFQuery(className: "Sessions")
        self.session = query.getObjectWithId(self.session?.objectId)
        var users = session?.objectForKey("active_users") as [String]
        users.removeAtIndex(find(users, localData.getUserID())!)
        session?["active_users"] = users
        session?.saveInBackground()
        self.checkIfSessionIsEmpty()
        self.performSegueWithIdentifier("popToCourseView", sender: self)
    }
    
    @IBAction func inviteFriends(sender: AnyObject) {
        if(!FBSession.activeSession().isOpen){
            let permission = ["public_profile", "user_friends"]
            FBSession.openActiveSessionWithReadPermissions(
                permission,
                allowLoginUI: true,
                completionHandler: { (session:FBSession!, state:FBSessionState, error:NSError!) in
                    
                    if(error == nil){
                        var alertView = UIAlertController(title: "Error Fetching Friends", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                        self.presentViewController(alertView, animated: true, completion: nil)
                    }
                    else if(session.isOpen){
                        self.inviteFriends(sender)
                    }
                }

            );
            return;
        }
        
        if(self.friendPickerController == nil){
            self.friendPickerController = FBFriendPickerViewController()
            self.friendPickerController.title = "Invite friends to Cramr"
            self.friendPickerController.delegate = self
        }
        
        self.friendPickerController.loadData()
        self.friendPickerController.clearSelection()
        self.presentViewController(self.friendPickerController, animated: true, completion: nil)
        
    }
    
     func facebookViewControllerDoneWasPressed(sender: AnyObject!) {
        var text = NSMutableString()
        let picker = sender as FBFriendPickerViewController
        
        for friend in picker.selection {
            var fdict = friend as NSDictionary
            var id = fdict.objectForKey("id") as String
            println(id)
            var innerquery = PFQuery(className: "User")
            innerquery.whereKey("userID", equalTo: id)
                
            var query = PFInstallation.query()
            query.whereKey("user", matchesQuery: innerquery)
            
            // Send a notification to all devices subscribed to the "Giants" channel.
            let push = PFPush()
            push.setChannel("a"+id)
            push.setMessage(localData.getUserID() + "Invited you to a session")
            push.sendPushInBackground()
            
            
//            //Send Push
//            var push = PFPush()
//            push.setQuery(query)
//            push.setMessage(localData.getUserID() + "Invited you to a session")
//            push.sendPushInBackground()
            
            text.appendString(friend.name)
        }
        self.fillTextBoxAndDismiss(text)
        
    }
    
    
    func facebookViewControllerCancelWasPressed(sender: AnyObject!) {
        self.fillTextBoxAndDismiss("Canceled")
    }
    
    func fillTextBoxAndDismiss(text: String){
        self.selectedFriendsView.text = text
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func checkIfSessionIsEmpty() {
        var users = session?["active_users"] as [String]
        if users.isEmpty {
            session?.deleteInBackground()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGrayColor()
        
        navigationItem.hidesBackButton = true
        if self.session == nil {
            self.session == localData.getSessionID() as String
        }
        
        if self.session != nil && self.session != "" {
            var fullCourseName = (self.session?.objectForKey("course") as String)
            className.text = getCourseID(fullCourseName)
            desciptLabel.text = "We're working on: " + (self.session?.objectForKey("description") as String)
            locationLabel.text = "We're working at: " + (self.session?.objectForKey("location") as String)
            
            desciptLabel.sizeToFit()
            locationLabel.sizeToFit()
            
            currentUsers.text = ""
            var currentUserList = (self.session?.objectForKey("active_users") as [String])
            for userId in currentUserList {
                var query = PFUser.query();
                query.whereKey("userID", equalTo: userId)
                var user = query.getFirstObject()
                //var user = query.getObjectWithId(userId) as PFObject
                var userName = user.objectForKey("username") as String
                if currentUsers.text == "" {
                    currentUsers.text = userName
                } else {
                    currentUsers.text = currentUsers.text! + "\n" + userName
                }
            }
            
            currentUsers.numberOfLines = 0
            currentUsers.sizeToFit()
            desciptLabel.numberOfLines = 0
            desciptLabel.sizeToFit()
        } else {
//            desciptLabel.text = "NO SESSION"
        }

    }
    
}
