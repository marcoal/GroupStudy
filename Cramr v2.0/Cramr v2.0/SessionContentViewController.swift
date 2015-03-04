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
            addBlur(self.view, [self.currentUsersLabel])
        }
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
        self.setLabels()
        //WHERE DO WE PUT THIS???
        setupMap()
        addBlur(self.view, [self.descript, self.locationLabel])
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushToLockedFromJoin" {
            (segue.destinationViewController as SessionLockedViewController).session = self.session
        }
    }
    
    
}