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
            //currentUsersLabel.sizeToFit()
            
        }
        displayCurrentUsers()
        addBlur(self.view, [self.currentUsersLabel])
    }
    
    func setLabels() {
        descript.text = "  We're working on: " + (session["description"]! as String)
        locationLabel.text = "  We're working at: " + (session["location"]! as String)
        //locationLabel.sizeToFit()
        currentUsersLabel.text = ""
        descript.numberOfLines = 0
        //descript.sizeToFit()
        (UIApplication.sharedApplication().delegate as AppDelegate).getSessionUsersAD(session["sessionID"]!, cb: setUsersLabelCallback)
    }
    
    func displayCurrentUsers() {
        self.currentMembersScrollView.backgroundColor = UIColor.clearColor()
        
        self.currentMembersScrollView.canCancelContentTouches = false
        self.currentMembersScrollView.indicatorStyle = UIScrollViewIndicatorStyle.White
        self.currentMembersScrollView.clipsToBounds = true
        self.currentMembersScrollView.scrollEnabled = true
        //self.currentMembersScrollView.pagingEnabled = true
        
        
        var cx = CGFloat(5)
        var cy = CGFloat(25)
        
        for var i = 0; i < 10; i++ {
            var im = UIImage(named: "test_background")
            
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
        
        self.currentMembersScrollView.contentSize = CGSizeMake(cx, self.currentMembersScrollView.bounds.size.height)
        
        //addBlur(self.view, [self.currentMembersScrollView])
    }
    
    
    func setupMap() {
        var latitude: Double = (self.session["latitude"]! as NSString).doubleValue
        var longitude: Double = (self.session["longitude"]! as NSString).doubleValue
        
        var camera = GMSCameraPosition.cameraWithLatitude(latitude as CLLocationDegrees, longitude: longitude as CLLocationDegrees, zoom: 17.0)
        self.sessionMapView.camera = camera
        self.sessionMapView.myLocationEnabled = true
        
        var position = CLLocationCoordinate2DMake(latitude, longitude)
        var marker = GMSMarker(position: position)
        
        //        Failed attempt to resize image
        //        var originalImage = UIImage(named: "blue_map_icon")
        //        var size = originalImage?.size
        //        UIGraphicsBeginImageContextWithOptions(size!, false, 0.0)
        //        var markerContainer = CGRectMake(0, 0, 30, 30)
        //        originalImage?.drawInRect(markerContainer)
        //        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        //        UIGraphicsEndImageContext()
        //        marker.icon = UIImage(named: "blue_map_icon")
        marker.icon = UIImage(named: "blue_map_marker")
        marker.map = self.sessionMapView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .grayColor()
        
        //WHERE DO WE PUT THIS???
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