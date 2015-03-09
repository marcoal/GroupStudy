//
//  SessionContentViewController.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 2/4/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation

class SessionContentViewController: UIViewController {
    
    var session: [String: String]!
    
    @IBOutlet weak var descript: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var currentUsersLabel: UILabel!
    
    @IBOutlet weak var sessionMapView: GMSMapView!
    
    @IBOutlet weak var currentMembersScrollView: UIScrollView!
    
    var currentMembersDict = [String : String]()
    
    func joinSessionCallback() {
        self.performSegueWithIdentifier("pushToLockedFromJoin", sender: self)
    }
    
    
    @IBAction func joinButton(sender: AnyObject) {
        (UIApplication.sharedApplication().delegate as AppDelegate).joinSessionAD(session["sessionID"]!, userID: localData.getUserID(), cb: joinSessionCallback)
    }
    
    func setUsersLabelCallback(userNamesAndIds: [(String, String)]) {
        for elem in userNamesAndIds {
            var userName = elem.0
            var userID = elem.1
            
            if currentUsersLabel.text == "" {
                currentUsersLabel.text = userName
            } else {
                currentUsersLabel.text = currentUsersLabel.text! + "\n" + userName
            }
            currentUsersLabel.numberOfLines = 0
            
        }
        addBlur(self.view, [self.currentUsersLabel])
        
        var userIDs = [String]()
        for elem in userNamesAndIds {
            userIDs.append(elem.1)
            self.currentMembersDict[elem.1] = elem.0
        }
        
        (UIApplication.sharedApplication().delegate as AppDelegate).getSessionUsersPicturesAD(userIDs, cb: displayCurrentUsers)
        
    }
    
    func setLabels() {
        descript.text = "  We're working on: " + (session["description"]! as String)
        locationLabel.text = "  We're working at: " + (session["location"]! as String)
        currentUsersLabel.text = ""
        descript.numberOfLines = 0
        (UIApplication.sharedApplication().delegate as AppDelegate).getSessionUsersAD(session["sessionID"]!, cb: setUsersLabelCallback)
        
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
            
            self.currentMembersScrollView.addSubview(imView)
            
            cx += imView.frame.size.width + 10
        }
        
        var lx = CGFloat(5)
        var ly = CGFloat(0)
        
        for user in pictDict.keys {
            var label = UILabel()
            //label.text = currentMembersDict[user]
            label.text = getShortName(currentMembersDict[user]!)
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
        
        self.currentMembersScrollView.contentSize = CGSizeMake(cx, self.currentMembersScrollView.bounds.size.height)
        
    }
    
    
    func setupMap() {
        var latitude: Double = (self.session["latitude"]! as NSString).doubleValue
        var longitude: Double = (self.session["longitude"]! as NSString).doubleValue
        
        var camera = GMSCameraPosition.cameraWithLatitude(latitude as CLLocationDegrees, longitude: longitude as CLLocationDegrees, zoom: 17.0)
        self.sessionMapView.camera = camera
        self.sessionMapView.myLocationEnabled = true
        
        var position = CLLocationCoordinate2DMake(latitude, longitude)
        var marker = GMSMarker(position: position)
        marker.icon = UIImage(named: "blue_map_marker")
        marker.map = self.sessionMapView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .grayColor()
        
        setupMap()
        self.setLabels()
        addBlur(self.view, [self.descript, self.locationLabel, self.currentMembersScrollView])
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushToLockedFromJoin" {
            (segue.destinationViewController as SessionLockedViewController).session = self.session
        }
    }
    
    
}