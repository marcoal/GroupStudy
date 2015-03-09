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
    

    @IBOutlet weak var leaveButton: UIButton!

    @IBOutlet weak var desciptLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var lockedMapView: GMSMapView!
    
    @IBOutlet weak var currentMembersScrollView: UIScrollView!
    
    var currentMembersDict = [String : String]()
    
    var session: [String: String]! {
        didSet {
            
        }
    }
    
    func leaveSessionCallback() {
        self.performSegueWithIdentifier("popToCourseView", sender: self)
    }
    
    @IBAction func leaveSession(sender: AnyObject) {
        (UIApplication.sharedApplication().delegate as AppDelegate).leaveSessionAD((UIApplication.sharedApplication().delegate as AppDelegate).localData.getUserID(), sessionID: self.session["sessionID"]!, cb: self.leaveSessionCallback)
    }
    
    @IBAction func inviteFriends(sender: AnyObject) {
        if(!FBSession.activeSession().isOpen){
            let permission = ["public_profile", "user_friends"]
            FBSession.openActiveSessionWithReadPermissions(
                permission,
                allowLoginUI: true,
                completionHandler: { (session:FBSession!, state:FBSessionState, error:NSError!) in
                    
                    if(error != nil){
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
            let data = [
                "alert" : (UIApplication.sharedApplication().delegate as AppDelegate).localData.getUserName() + " invited you to work on " + course,
                "seshid" : (UIApplication.sharedApplication().delegate as AppDelegate).localData.getSessionID(),
                "courseName" : course,
                "message" :(UIApplication.sharedApplication().delegate as AppDelegate).localData.getUserName() + " invited you to work on " + course
            ]
            push.setData(data)
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
        self.dismissViewControllerAnimated(true, completion: nil)
        //addBlur(self.view, [self.selectedFriendsView, self.locationLabel, self.desciptLabel, self.className])
    }
    
    func displayCurrentUsers(pictDict : [String: UIImage]) {
        self.currentMembersScrollView.backgroundColor = UIColor.clearColor()
        
        self.currentMembersScrollView.canCancelContentTouches = false
        self.currentMembersScrollView.indicatorStyle = UIScrollViewIndicatorStyle.White
        self.currentMembersScrollView.clipsToBounds = true
        self.currentMembersScrollView.scrollEnabled = true
        
        var cx = CGFloat(5)
        var cy = CGFloat(25)
        
        for im in pictDict.values {
            var imView = UIImageView(image: im)
            
            var rect = imView.frame
            rect.size.height = 50.0
            rect.size.width = 50.0
            rect.origin.x = cx
            rect.origin.y = cy
            
            imView.frame = rect
            imView.layer.cornerRadius = imView.frame.size.width / 2
            imView.clipsToBounds = true
            
            imView.layer.borderWidth = 1.0
            imView.layer.borderColor = cramrBlue.CGColor
            
            self.currentMembersScrollView.addSubview(imView)
            
            cx += imView.frame.size.width + 10
        }
        
        var lx = CGFloat(5)
        var ly = CGFloat(0)
        
        for user in pictDict.keys {
            var label = UILabel()
            label.text = getShortName(currentMembersDict[user]!)
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont(name: label.font.fontName, size: 10)
            label.textColor = cramrBlue
            var labelRect = CGRect()
            labelRect.size.height = 25.0
            labelRect.size.width = 50.0
            labelRect.origin.x = lx
            labelRect.origin.y = ly
            
            label.frame = labelRect
            self.currentMembersScrollView.addSubview(label)
            
            lx += label.frame.size.width + 10
        }
        
        var addButton = UIButton() //.buttonWithType(UIButtonType.ContactAdd) as UIButton
        addButton.setImage(UIImage(named: "blue_plus_icon"), forState: UIControlState.Normal)
        var buttonRect = CGRect()
        buttonRect.size.height = 50.0
        buttonRect.size.width = 50.0
        buttonRect.origin.x = cx
        buttonRect.origin.y = cy
        
        addButton.frame = buttonRect
        addButton.tintColor = cramrBlue
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        addButton.addTarget(self, action: "inviteFriends:", forControlEvents: UIControlEvents.TouchUpInside)
        
        addButton.layer.borderWidth = 1.0
        addButton.layer.borderColor = cramrBlue.CGColor
        cx += addButton.frame.size.width + 10
        self.currentMembersScrollView.addSubview(addButton)
        
        self.currentMembersScrollView.contentSize = CGSizeMake(cx, self.currentMembersScrollView.bounds.size.height)
        
    }
    
    
    func currentUsersCallback(userNamesAndIds: [(String, String)]) {
        
        var userIDs = [String]()
        for elem in userNamesAndIds {
            userIDs.append(elem.1)
            self.currentMembersDict[elem.1] = elem.0
        }
        
        (UIApplication.sharedApplication().delegate as AppDelegate).getSessionUsersPicturesAD(userIDs, cb: displayCurrentUsers)
    }
    
    func setupMap() {
        var latitude: Double = (self.session["latitude"]! as NSString).doubleValue
        var longitude: Double = (self.session["longitude"]! as NSString).doubleValue
        
        var camera = GMSCameraPosition.cameraWithLatitude(latitude as CLLocationDegrees, longitude: longitude as CLLocationDegrees, zoom: 17.0)
        self.lockedMapView.camera = camera
        self.lockedMapView.myLocationEnabled = true
        
        var position = CLLocationCoordinate2DMake(latitude, longitude)
        var marker = GMSMarker(position: position)
        marker.icon = UIImage(named: "blue_map_marker")
        marker.map = self.lockedMapView
        
        
        self.lockedMapView.layer.borderWidth = 1.0
        self.lockedMapView.layer.borderColor = cramrBlue.CGColor
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGrayColor()
        
        
        navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = cramrBlue
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

        //        self.navigationController?.navigationBarHidden = true
        
        //        if self.session == nil {
        //            self.session == localData.getSessionID() as String
        //        }
        
        if self.session != nil {
            var fullCourseName = (self.session["course"]! as String)
            desciptLabel.text = "  We're working on: " + (self.session["description"]! as String)
            locationLabel.text = "  We're working at: " + (self.session["location"]! as String)
            
            desciptLabel.numberOfLines = 0
            
            self.title = getCourseID(fullCourseName)
            setupMap()
            addBlur(self.view, [self.desciptLabel, self.locationLabel, self.currentMembersScrollView])
            (UIApplication.sharedApplication().delegate as AppDelegate).getSessionUsersAD(session["sessionID"]!, cb: currentUsersCallback)
        } else {
            //            desciptLabel.text = "NO SESSION"
        }
        
    }
    
}
