//
//  SessionCreationViewController.swift
//  Cramr v2.0
//
//  Created by Roberto Alvarez on 3/1/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import MapKit


class SessionCreationViewController : UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    
    var courseName: String?  {
        didSet {
            self.title = getCourseID(self.courseName!)
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
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
        } else if appDelegate.isConnectedToNetwork() {
            var center: CGPoint = mapView.center
            var loc: CLLocationCoordinate2D = mapView.camera.target
            addSession(locationText, description: descriptionText, geoTag: loc)
        } else {
            checkForNetwork(self, self.appDelegate)
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
    
    func addSession(location: String, description: String, geoTag: CLLocationCoordinate2D) {
        (UIApplication.sharedApplication().delegate as AppDelegate).addSessionAD((UIApplication.sharedApplication().delegate as AppDelegate).localData.getUserID(), courseName: self.courseName!, description: description, location: location, geoTag: geoTag, cb: addSessionCallback)
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
            mapView.settings.myLocationButton = false
            addMapButton(self.view, self)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            mapView.camera = GMSCameraPosition(target : location.coordinate, zoom: 17, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
  
    @IBAction func tappedLocationButton(sender: AnyObject) {
        if (self.mapView.myLocation != nil) {
            self.mapView.animateToCameraPosition(GMSCameraPosition(target: self.mapView.myLocation.coordinate, zoom: 18, bearing: 0, viewingAngle: 0))
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    
    func setupMap() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.mapView.padding = UIEdgeInsets(top: 100, left: 0, bottom: 70, right: 0)
        
        var centered: CGPoint = mapView.center
        var markerCenter = ((self.mapView.frame.height - 70) - (self.locationLabel.frame.origin.y + self.locationLabel.frame.height))/2.0
        markerCenter -= self.pin.frame.height / 2.0
        markerCenter += 64 //height of status plus nav bar, i think
        centered.y = markerCenter
        pin.center = centered
    }
    
    func shouldChangeTextInRange(range: UITextRange, replacementText: String) {

        
        
    }
    
    override func viewDidLoad() {
        descriptionField.delegate = self
        locationField.delegate = self
        
        // It breaks here
        self.view.backgroundColor = UIColor.whiteColor()
        //NSLog("couseName: " + self.courseName!)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        setupMap()
        
        addBlur(self.view, [self.descriptionLabel, self.locationLabel])
        self.view.bringSubviewToFront(self.descriptionField)
        self.view.bringSubviewToFront(self.locationField)
  
    }
    
}