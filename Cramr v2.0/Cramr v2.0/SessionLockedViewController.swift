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
    
    @IBOutlet weak var inviteFriendsButton: UIButton!
    
    @IBOutlet weak var leaveButton: UIButton!
    
    @IBOutlet weak var selectedFriendsView: UILabel!
    
    @IBOutlet weak var desciptLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var currentUsers: UILabel!
    
    @IBOutlet weak var lockedMapView: GMSMapView!
    
    var session: [String: String]! {
        didSet {
            
        }
    }
    
    func leaveSessionCallback() {
        self.performSegueWithIdentifier("popToCourseView", sender: self)
    }
    
    @IBAction func leaveSession(sender: AnyObject) {
        (UIApplication.sharedApplication().delegate as AppDelegate).leaveSessionAD(localData.getUserID(), sessionID: self.session["sessionID"]!, cb: self.leaveSessionCallback)
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
            (UIApplication.sharedApplication().delegate as AppDelegate).isUserInSessionAD(id, seshID: localData.getSessionID(), cb: self.sendPushCallback)
            
        }
        
    }

    func sendPushCallback(userid: String) {
        let push = PFPush()
        push.setChannel("a"+userid)
        
        
        var course = self.session["course"]! as String
        let data = [
            "alert" : localData.getUserName() + " invited you to work on " + getCourseName(course),
            "seshid" : localData.getSessionID(),
            "courseName" : course,
            "message" :localData.getUserName() + " invited you to work on " + getCourseName(course)
        ]
        push.setData(data)
        push.sendPushInBackground()
    }
    
    func facebookViewControllerCancelWasPressed(sender: AnyObject!) {
        self.fillTextBoxAndDismiss("Canceled")
    }
    
    func fillTextBoxAndDismiss(text: String){
        self.selectedFriendsView.text = text
        self.dismissViewControllerAnimated(true, completion: nil)
        //addBlur(self.view, [self.selectedFriendsView, self.locationLabel, self.desciptLabel, self.className])
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
        
        addBlur(self.view, [self.currentUsers])
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
        
        //        Failed attempt to resize marker icon
        //        var originalImage = UIImage(named: "blue_map_icon")
        //        var size = originalImage?.size
        //        UIGraphicsBeginImageContextWithOptions(size!, false, 0.0)
        //        var markerContainer = CGRectMake(0, 0, 30, 30)
        //        originalImage?.drawInRect(markerContainer)
        //        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        //        UIGraphicsEndImageContext()
        //        marker.icon = UIImage(named: "blue_map_icon")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGrayColor()
        navigationItem.hidesBackButton = true
        //        self.navigationController?.navigationBarHidden = true
        
        //        if self.session == nil {
        //            self.session == localData.getSessionID() as String
        //        }
        
        if self.session != nil {
            var fullCourseName = (self.session["course"]! as String)
            desciptLabel.text = "  We're working on: " + (self.session["description"]! as String)
            locationLabel.text = "  We're working at: " + (self.session["location"]! as String)
            
            //desciptLabel.sizeToFit()
            //locationLabel.sizeToFit()
            
            currentUsers.text = ""
            currentUsers.numberOfLines = 0
            //currentUsers.sizeToFit()
            desciptLabel.numberOfLines = 0
            //desciptLabel.sizeToFit()
            
            self.title = getCourseID(fullCourseName)
            setupMap()
            addBlur(self.view, [self.desciptLabel, self.locationLabel])
            (UIApplication.sharedApplication().delegate as AppDelegate).getSessionUsersAD(session["sessionID"]!, cb: currentUsersCallback)
        } else {
            //            desciptLabel.text = "NO SESSION"
        }
        
    }
    
}
