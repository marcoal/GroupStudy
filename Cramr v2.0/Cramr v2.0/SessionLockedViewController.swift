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
    
    @IBOutlet weak var selectedFriendsView: UILabel!
    
    @IBOutlet weak var className: UILabel!
    
    @IBOutlet weak var desciptLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var currentUsers: UILabel!
    
    var session: [String: String]! {
        didSet {
            
        }
    }
    
    func leaveSessionCallback() {
        self.performSegueWithIdentifier("popToCourseView", sender: self)
    }
    
    @IBAction func leaveSession(sender: AnyObject) {
        (UIApplication.sharedApplication().delegate as AppDelegate).leaveSessionAD(localData.getUserID(), sessionID: self.session["sessionID"]!, cb: leaveSessionCallback)
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

            var course = self.session["course"]! as String
            push.setMessage(localData.getUserName() + " invited you to work on " + course)

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
    
    func currentUsersCallback(userNamesAndIds: [(String, String)]) {
        for elem in userNamesAndIds {
            var userName = elem.0
            var userID = elem.1
            if currentUsers.text == "" {
                currentUsers.text = userName
            } else {
                currentUsers.text = currentUsers.text! + "\n" + userName
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGrayColor()
        
        navigationItem.hidesBackButton = true

//        if self.session == nil {
//            self.session == localData.getSessionID() as String
//        }
        
        if self.session != nil {
            var fullCourseName = (self.session["course"]! as String)
            className.text = getCourseID(fullCourseName)
            desciptLabel.text = "We're working on: " + (self.session["description"]! as String)
            locationLabel.text = "We're working at: " + (self.session["location"]! as String)
            
            desciptLabel.sizeToFit()
            locationLabel.sizeToFit()
            
            currentUsers.text = ""
            currentUsers.numberOfLines = 0
            currentUsers.sizeToFit()
            desciptLabel.numberOfLines = 0
            desciptLabel.sizeToFit()
            (UIApplication.sharedApplication().delegate as AppDelegate).getSessionUsersAD(session["sessionID"]!, cb: currentUsersCallback)
        } else {
//            desciptLabel.text = "NO SESSION"
        }

    }
    
}
