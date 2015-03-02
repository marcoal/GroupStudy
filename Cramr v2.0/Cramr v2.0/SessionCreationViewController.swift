//
//  SessionCreationViewController.swift
//  Cramr v2.0
//
//  Created by Roberto Alvarez on 3/1/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import MapKit


class SessionCreationViewController : UIViewController, CLLocationManagerDelegate {
    

    
    var courseName: String?  {
        didSet {
            
        }
    }
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var pin: UIImageView!
    
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
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            mapView.camera = GMSCameraPosition(target : location.coordinate, zoom: 17, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }

    func setupMap() {
        

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        
        var centered: CGPoint = mapView.center
        centered.y -= self.pin.frame.height / 2.0
        pin.center = centered

    }
    
    override func viewDidLoad() {
        // It breaks here
        self.view.backgroundColor = .lightGrayColor()
        NSLog("couseName: " + self.courseName!)
        self.title = getCourseID(self.courseName!)
        self.navigationItem.leftBarButtonItem?.tintColor = cramrBlue
        self.navigationItem.backBarButtonItem?.tintColor = cramrBlue
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = cramrBlue
        setupMap()
    }
    
}